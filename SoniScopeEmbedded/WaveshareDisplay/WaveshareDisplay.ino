#include <Arduino.h>
#include <esp_display_panel.hpp>
#include <lvgl.h>
#include "lvgl_v8_port.h"
#include "ui.h"  // Exported from SquareLine
#include "PWR_Key.h"

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "ESP_I2S.h"

using namespace esp_panel::drivers;
using namespace esp_panel::board;

// === BLE UUIDs ===
#define AUDIO_SERVICE_UUID         "93ae16d8-749c-4f7c-846c-dd4776f76676"
#define AUDIO_CHARACTERISTIC_UUID  "1094c6d5-cf3c-4294-bf2a-9aada4343ba0"
#define SCREEN_CHARACTERISTIC_UUID "1f964148-2bb7-4d92-971f-419e61ac385b"

// === I2S Pins ===
#define I2S_WS 44
#define I2S_SCK 43
#define I2S_DIN 12

// === BACKLIGHT ===
#define BACKLIGHT_PIN 45

// === BLE Globals ===
BLEServer* pServer = nullptr;
BLECharacteristic* screenCharacteristic = nullptr;
BLECharacteristic* audioCharacteristic = nullptr;
BLE2902* audioDescriptor = nullptr;
bool deviceConnected = false;

// === I2S ===
I2SClass i2s;

// === LCD Panel ===
Board* board = nullptr;

unsigned long lastTouchTime = 0;
const unsigned long sleepTimeout = 40000;
bool sleeping = false;
bool wasOnHome = false;

const uint32_t sampleRate = 16000;

void stopBLE();
void restartBLE();

// === BLE Write Handler ===
class ScreenCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) override {
    std::string rxValue((char*)pCharacteristic->getData(), pCharacteristic->getLength());
    rxValue.erase(std::remove_if(rxValue.begin(), rxValue.end(), ::isspace), rxValue.end());

    Serial.print("Received BLE data: ");
    Serial.println(rxValue.c_str());

    if (rxValue == "home") {
      lv_async_call([](void*) { lv_scr_load_anim(ui_Home, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false); }, nullptr);
    } else if (rxValue == "connected") {
      lv_async_call([](void*) { lv_scr_load_anim(ui_Connected, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false); }, nullptr);
    } else if (rxValue == "recording") {
      lv_async_call([](void*) { lv_scr_load_anim(ui_Recording, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false); }, nullptr);
    } else if (rxValue == "complete") {
      lv_async_call([](void*) { lv_scr_load_anim(ui_Complete, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false); }, nullptr);
    } else if (rxValue == "healthy") {
      lv_async_call([](void*) { lv_scr_load_anim(ui_Healthy, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false); }, nullptr);
    } else if (rxValue == "abnormal") {
      lv_async_call([](void*) { lv_scr_load_anim(ui_Abnormal, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false); }, nullptr);
    } else {
      Serial.println("Unknown screen command.");
    }
  }
};

// === BLE Server Callbacks ===
class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) override {
    deviceConnected = true;
    Serial.println("BLE device connected");
  }
  void onDisconnect(BLEServer* pServer) override {
    deviceConnected = false;
    Serial.println("BLE device disconnected");
    if (!sleeping) BLEDevice::startAdvertising();
  }
};

// === BLE Setup ===
void setupBLE() {
  BLEDevice::init("SoniScope");
  BLEDevice::setMTU(350);
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService* service = pServer->createService(AUDIO_SERVICE_UUID);

  screenCharacteristic = service->createCharacteristic(
    SCREEN_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_WRITE_NR
  );
  screenCharacteristic->setCallbacks(new ScreenCallbacks());
  screenCharacteristic->addDescriptor(new BLE2902());

  audioCharacteristic = service->createCharacteristic(
    AUDIO_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_NOTIFY | BLECharacteristic::PROPERTY_READ
  );
  audioDescriptor = new BLE2902();
  audioCharacteristic->addDescriptor(audioDescriptor);

  service->start();

  BLEAdvertising* advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(AUDIO_SERVICE_UUID);
  advertising->setScanResponse(true);
  advertising->start();

  Serial.println("BLE advertising as 'SoniScope'");
}

void stopBLE() {
  if (pServer) {
    pServer->disconnect(0);
  }
  BLEDevice::getAdvertising()->stop();
  Serial.println("BLE stopped");
}

void restartBLE() {
  BLEDevice::getAdvertising()->start();
  Serial.println("BLE restarted");
}

void setupI2S() {
  i2s.setPins(I2S_SCK, I2S_WS, -1, I2S_DIN);
  i2s.setTimeout(1000);

  if (!i2s.begin(I2S_MODE_STD, sampleRate, I2S_DATA_BIT_WIDTH_32BIT, I2S_SLOT_MODE_MONO, I2S_STD_SLOT_LEFT)) {
    Serial.println("Failed to initialize I2S");
    while (true);
  }

  Serial.println("I2S initialized");
}

void wakeupFromTouch() {
  if (sleeping) {
    Serial.println("Woke up from sleep via touch");
    analogWrite(BACKLIGHT_PIN, 255);
    restartBLE();
    sleeping = false;
  }
  lastTouchTime = millis();
}

bool isHomeScreenActive() {
  return lv_scr_act() == ui_Home;
}

void setup() {
  Serial.begin(115200);
  delay(1000);

  PWR_Init();

  pinMode(BACKLIGHT_PIN, OUTPUT);
  analogWrite(BACKLIGHT_PIN, 255);

  Serial.println("Initializing board");
  board = new Board();
  board->init();
  assert(board->begin());

  board->getLCD()->invertColor(true);
  lvgl_port_init(board->getLCD(), board->getTouch());

  lvgl_port_lock(-1);
  ui_init();
  lv_scr_load(ui_Home);
  lvgl_port_unlock();

  setupBLE();
  setupI2S();
  lastTouchTime = millis();
}

void loop() {  
  bool nowOnHome = isHomeScreenActive();
  if (nowOnHome && !wasOnHome) {
    lastTouchTime = millis();
  }
  wasOnHome = nowOnHome;

  if (!sleeping && nowOnHome && !deviceConnected && millis() - lastTouchTime > sleepTimeout) {
    Serial.println("Dimming screen and disabling BLE");
    analogWrite(BACKLIGHT_PIN, 10);
    stopBLE();
    sleeping = true;
  }

  if (!sleeping && deviceConnected && audioDescriptor->getNotifications() && lv_scr_act() == ui_Recording) {
    const size_t bufferSize = 128; // Smaller buffer for more frequent reads
    uint16_t sampleBuffer[bufferSize];
    size_t sampleIndex = 0;

    while (sampleIndex < bufferSize) {
      int32_t sample = i2s.read();
      i2s.read(); // discard second channel in stereo

      if (sample != -1) {
        sample = (sample >> 8) & 0xFFFFFF; // strip LSB if needed
        sample -= (sample & 0x800000) ? 0x1000000 : 0; // sign extend if negative
        sample = sample >> 8; // compress to ~16 bits
        sample = constrain(sample + 32768, 0, 65535);
        sampleBuffer[sampleIndex++] = (uint16_t)(sample);
        Serial.println(sample);
      }

    }

    // Send the buffer over BLE
    audioCharacteristic->setValue((uint8_t*)sampleBuffer, sampleIndex * sizeof(uint16_t));
    audioCharacteristic->notify();
}


  lvgl_port_lock(-1);
  lv_indev_t* indev = lv_indev_get_next(nullptr);
  if (indev) {
    lv_indev_data_t data;
    indev->driver->read_cb(indev->driver, &data);
    if (data.state == LV_INDEV_STATE_PR) {
      wakeupFromTouch();
    }
  }
  lvgl_port_unlock();

  delay(9);
}