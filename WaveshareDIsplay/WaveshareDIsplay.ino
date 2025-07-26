#include <Arduino.h>
#include <esp_display_panel.hpp>
#include <lvgl.h>
#include "lvgl_v8_port.h"
#include "ui.h"  // Exported from SquareLine

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

using namespace esp_panel::drivers;
using namespace esp_panel::board;

// === BLE UUIDs ===
#define SCREEN_SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define SCREEN_CHARACTERISTIC_UUID "abcd1234-5678-90ab-cdef-1234567890ab"

#define AUDIO_SERVICE_UUID         "180A"  // Could be custom
#define AUDIO_CHARACTERISTIC_UUID  "2A57"  // Custom/placeholder UUID for audio

// BLE globals
BLEServer* pServer = nullptr;
BLECharacteristic* screenCharacteristic = nullptr;
BLECharacteristic* audioCharacteristic = nullptr;

// LCD panel board object
Board* board = nullptr;

// === BLE Write Callback for Screen Switching ===
class ScreenCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic* pCharacteristic) override {
    std::string rxValue = std::string((char*)pCharacteristic->getData(), pCharacteristic->getLength());

    Serial.print("Received BLE data: ");
    Serial.println(rxValue.c_str());

    if (rxValue == "home") {
      lv_scr_load_anim(ui_Home, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "connected") {
      lv_scr_load_anim(ui_Connected, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "recording") {
      lv_scr_load_anim(ui_Recording, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "complete") {
      lv_scr_load_anim(ui_Complete, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "healthy") {
      lv_scr_load_anim(ui_Healthy, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "abnormal") {
      lv_scr_load_anim(ui_Abnormal, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else {
      Serial.println("Unknown screen command.");
    }
  }
};

// === BLE Setup ===
void setupBLE() {
  BLEDevice::init("SoniScope");
  pServer = BLEDevice::createServer();

  // Screen switching service
  BLEService* screenService = pServer->createService(SCREEN_SERVICE_UUID);
  screenCharacteristic = screenService->createCharacteristic(
    SCREEN_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_WRITE
  );
  screenCharacteristic->setCallbacks(new ScreenCallbacks());
  screenCharacteristic->addDescriptor(new BLE2902());
  screenService->start();

  // Audio streaming service
  BLEService* audioService = pServer->createService(AUDIO_SERVICE_UUID);
  audioCharacteristic = audioService->createCharacteristic(
    AUDIO_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_NOTIFY
  );
  audioCharacteristic->addDescriptor(new BLE2902());
  audioService->start();

  // Advertise both services
  BLEAdvertising* advertising = BLEDevice::getAdvertising();
  advertising->addServiceUUID(SCREEN_SERVICE_UUID);
  advertising->addServiceUUID(AUDIO_SERVICE_UUID);
  advertising->setScanResponse(true);
  advertising->start();

  Serial.println("BLE advertising as 'SoniScope'");
}

// === Setup ===
void setup() {
  Serial.begin(115200);
  delay(1000);

  Serial.println("Initializing board");
  board = new Board();
  board->init();

#if LVGL_PORT_AVOID_TEARING_MODE
  auto lcd = board->getLCD();
  lcd->configFrameBufferNumber(LVGL_PORT_DISP_BUFFER_NUM);
#if ESP_PANEL_DRIVERS_BUS_ENABLE_RGB && CONFIG_IDF_TARGET_ESP32S3
  auto lcd_bus = lcd->getBus();
  if (lcd_bus->getBasicAttributes().type == ESP_PANEL_BUS_TYPE_RGB) {
    static_cast<BusRGB*>(lcd_bus)->configRGB_BounceBufferSize(lcd->getFrameWidth() * 10);
  }
#endif
#endif

  setupBLE();

  assert(board->begin());
  board->getLCD()->invertColor(true);   
  Serial.println("Initializing LVGL");
  lvgl_port_init(board->getLCD(), board->getTouch());

  Serial.println("Loading UI");
  lvgl_port_lock(-1);
  ui_init();                 // Initialize all SquareLine UI screens
  lv_scr_load(ui_Home);     // Default screen at startup
  lvgl_port_unlock();
}

// === Main Loop ===
void loop() {
  static unsigned long lastSend = 0;

  // Simulated audio stream
  if (millis() - lastSend > 100) {  // Every 100ms
    lastSend = millis();

    if (audioCharacteristic->getSubscribed()) {
      uint16_t sample = analogRead(A0);  // Simulated microphone input
      uint8_t audioData[2] = {
        highByte(sample),
        lowByte(sample)
      };
      audioCharacteristic->setValue(audioData, sizeof(audioData));
      audioCharacteristic->notify();
    }
  }

  delay(5);  // Let LVGL run
}
