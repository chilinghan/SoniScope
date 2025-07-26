#include <Arduino.h>
#include <esp_display_panel.hpp>
#include <lvgl.h>
#include "lvgl_v8_port.h"
#include "ui.h"  // From SquareLine

#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

using namespace esp_panel::drivers;
using namespace esp_panel::board;

// BLE UUIDs
#define SERVICE_UUID        "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_UUID "abcd1234-5678-90ab-cdef-1234567890ab"

// BLE globals
BLEServer *pServer = nullptr;
BLECharacteristic *pCharacteristic = nullptr;

// LCD panel board object
Board *board = nullptr;

// === BLE Write Callback ===
class MyCallbacks : public BLECharacteristicCallbacks {
  void onWrite(BLECharacteristic *pCharacteristic) override {
    std::string rxValue = std::string((char*)pCharacteristic->getData(), pCharacteristic->getLength());

    Serial.print("Received BLE data: ");
    Serial.println(rxValue.c_str());

    if (rxValue == "screen1") {
        lv_scr_load_anim(ui_Screen1, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "screen2") {
        lv_scr_load_anim(ui_Screen2, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "screen3") {
        lv_scr_load_anim(ui_Screen3, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else if (rxValue == "screen4") {
        lv_scr_load_anim(ui_Screen4, LV_SCR_LOAD_ANIM_MOVE_LEFT, 300, 0, false);
    } else {
        Serial.println("Unknown screen command.");
    }
  }
};

// === Initialize BLE Peripheral ===
void setupBLE() {
    BLEDevice::init("ESP32_ScreenControl");
    pServer = BLEDevice::createServer();

    BLEService *pService = pServer->createService(SERVICE_UUID);

    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_WRITE
    );

    pCharacteristic->setCallbacks(new MyCallbacks());
    pCharacteristic->addDescriptor(new BLE2902());

    pService->start();

    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->start();

    Serial.println("BLE advertising started as 'ESP32_ScreenControl'");
}

// === Setup ===
void setup() {
    Serial.begin(115200);
    delay(1000);  // Give serial monitor time

    Serial.println("Initializing board");
    board = new Board();
    board->init();

#if LVGL_PORT_AVOID_TEARING_MODE
    auto lcd = board->getLCD();
    lcd->configFrameBufferNumber(LVGL_PORT_DISP_BUFFER_NUM);

#if ESP_PANEL_DRIVERS_BUS_ENABLE_RGB && CONFIG_IDF_TARGET_ESP32S3
    auto lcd_bus = lcd->getBus();
    if (lcd_bus->getBasicAttributes().type == ESP_PANEL_BUS_TYPE_RGB) {
        static_cast<BusRGB *>(lcd_bus)->configRGB_BounceBufferSize(lcd->getFrameWidth() * 10);
    }
#endif
#endif

    setupBLE();  // Start BLE advertising

    assert(board->begin());

    Serial.println("Initializing LVGL");
    lvgl_port_init(board->getLCD(), board->getTouch());

    Serial.println("Creating UI from SquareLine");
    lvgl_port_lock(-1);            // Lock for LVGL thread safety
    ui_init();                     // SquareLine UI init
    lv_scr_load(ui_Screen1);       // Start from Screen1
    lvgl_port_unlock();            // Unlock

}

// === Main Loop ===
void loop() {
    delay(5);  // Let LVGL handle background processing
}



