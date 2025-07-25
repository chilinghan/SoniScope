/*Using LVGL with Arduino requires some extra steps:
 *Be sure to read the docs here: https://docs.lvgl.io/master/get-started/platforms/arduino.html  */

#include "Display_ST77916.h"
// #include "RTC_PCF85063.h"
#include "LVGL_Driver.h"
#include "PWR_Key.h"
#include "BAT_Driver.h"
#include "ESP_I2S.h"
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

// BLE UUID constants
const char* BLE_SERVICE_UUID = "180A";
const char* BLE_AUDIO_CHAR_UUID = "2A57";

// === I2S Pins and Config ===
const uint8_t I2S_SCK = 48;
const uint8_t I2S_WS = 38;
const uint8_t I2S_DIN = 47;

// Globals
BLEServer* pServer = nullptr;
BLECharacteristic* pAudioStreamCharacteristic = nullptr;

bool deviceConnected = false;

I2SClass i2s;

void Psram_Inquiry() {
  char buffer[128];    /* Make sure buffer is enough for `sprintf` */
  sprintf(buffer, "   Biggest /     Free /    Total\n"
          "\t  SRAM : [%8d / %8d / %8d]\n"
          "\t PSRAM : [%8d / %8d / %8d]",
          heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL),
          heap_caps_get_free_size(MALLOC_CAP_INTERNAL),
          heap_caps_get_total_size(MALLOC_CAP_INTERNAL),
          heap_caps_get_largest_free_block(MALLOC_CAP_SPIRAM),
          heap_caps_get_free_size(MALLOC_CAP_SPIRAM),
          heap_caps_get_total_size(MALLOC_CAP_SPIRAM));
  printf("MEM : %s\r\n", buffer);
}

void DriverTask(void *parameter) {
  while(1){
    PWR_Loop();
    BAT_Get_Volts();
    // RTC_Loop();
    Psram_Inquiry();
    vTaskDelay(pdMS_TO_TICKS(100));
  }
}
void Driver_Loop() {
  xTaskCreatePinnedToCore(
    DriverTask,           
    "DriverTask",         
    4096,                 
    NULL,                 
    3,                    
    NULL,                 
    0                     
  );  
}

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("BLE device connected");
  }
  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("BLE device disconnected");
  }
};

void InitBLE() {
  BLEDevice::init("ESP32-AudioDevice");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *audioService = pServer->createService(BLE_SERVICE_UUID);

  pAudioStreamCharacteristic = audioService->createCharacteristic(
    BLE_AUDIO_CHAR_UUID,
    BLECharacteristic::PROPERTY_WRITE | BLECharacteristic::PROPERTY_NOTIFY
  );

  audioService->start();

  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(BLE_SERVICE_UUID);
  pAdvertising->start();

  Serial.println("BLE Audio Service Started");
}

void setup() {
  Serial.begin(115200);


  // Set up the pins used for audio input
  i2s.setPins(I2S_SCK, I2S_WS, -1, I2S_DIN);

  // Initialize the I2S bus in standard mode
  if (!i2s.begin(I2S_MODE_STD, 44100, I2S_DATA_BIT_WIDTH_32BIT, I2S_SLOT_MODE_MONO, I2S_STD_SLOT_LEFT)) {
    Serial.println("Failed to initialize I2S bus!");
    return;
  }

  PWR_Init();
  //BAT_Init();
  //PCF85063_Init();
  TCA9554PWR_Init(0x00);
  Backlight_Init();

  LCD_Init();
  Lvgl_Init();

  Driver_Loop();

  InitBLE(); // Initialize BLE after all other init
}

void loop() {
  Lvgl_Loop();

  if (deviceConnected) {
    streamAudio();
  }
  
  // Example: Update BLE status every second (assuming 5ms delay below)
  if (deviceConnected) {
    pAudioStreamCharacteristic->setValue("0");
    pAudioStreamCharacteristic->notify();
  }

  vTaskDelay(pdMS_TO_TICKS(5));
}

void streamAudio() {
  int bytesRead = i2s.read();
  pAudioStreamCharacteristic->setValue(bytesRead);
  pAudioStreamCharacteristic->notify();

}
