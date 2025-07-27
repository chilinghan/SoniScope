#include "ESP_I2S.h"
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

const char* BLE_SERVICE_UUID = "180A";
const char* BLE_AUDIO_CHAR_UUID = "2A57";

BLEServer* pServer = nullptr;
BLECharacteristic* pAudioStreamCharacteristic = nullptr;

bool deviceConnected = false;

I2SClass i2s;

#define I2S_WS 44  // LRCK (yellow)
#define I2S_SCK 43 // BCLK (orange)
#define I2S_DIN 12 // Data In (SD)

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    Serial.println("BLE device connected");
  }
  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false;
    Serial.println("BLE device disconnected");
    BLEDevice::startAdvertising();
  }
};

void InitBLE() {
  BLEDevice::init("ESP32-AudioDevice");
  BLEDevice::setMTU(200);
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  BLEService *audioService = pServer->createService(BLE_SERVICE_UUID);

  pAudioStreamCharacteristic = audioService->createCharacteristic(
    BLE_AUDIO_CHAR_UUID,
    BLECharacteristic::PROPERTY_NOTIFY
  );

  audioService->start();

  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(BLE_SERVICE_UUID);
  pAdvertising->start();

  Serial.println("BLE Audio Service Started");
}

void InitI2S() {
  i2s.setPins(I2S_SCK, I2S_WS, -1, I2S_DIN);
  i2s.setTimeout(1000);

  if (!i2s.begin(I2S_MODE_STD, 44100, I2S_DATA_BIT_WIDTH_32BIT, I2S_SLOT_MODE_MONO)) {
    Serial.println("Failed to initialize I2S");
    while (true);
  }

  Serial.println("I2S initialized");
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  InitBLE();
  // pinMode(I2S_DIN, OUTPUT);
  // pinMode(I2S_SCK, OUTPUT);
  // pinMode(I2S_WS, OUTPUT);
  InitI2S();
}

void loop() {
  // Audio buffer
  char audioBuffer[256];
  size_t bytesRead = i2s.readBytes(audioBuffer, sizeof(audioBuffer));
  
  size_t sampleCount = bytesRead / 4; // number of samples = bytesRead / bytes per sample (4)
  int16_t sampleBuffer[sampleCount];

  Serial.printf("Read %u bytes\n", bytesRead);

  if (bytesRead > 0) {
    int32_t *samples = (int32_t *)audioBuffer;
    for (size_t i = 0; i < sampleCount; ++i) {
      int16_t audio = samples[i] >> 14;  // adjust shift as needed
      sampleBuffer[i] = audio;
      Serial.println(sampleBuffer[i]);
    }
    
    if (deviceConnected) {

      pAudioStreamCharacteristic->setValue((uint8_t*)sampleBuffer, sampleCount * sizeof(int16_t));
      pAudioStreamCharacteristic->notify();
    }
  }

  delay(500);

}

