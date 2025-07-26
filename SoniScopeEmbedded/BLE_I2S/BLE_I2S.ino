#include "ESP_I2S.h"
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>

const char* BLE_SERVICE_UUID = "180A";
const char* BLE_AUDIO_CHAR_UUID = "2A57";

BLEServer* pServer = nullptr;
BLECharacteristic* pAudioStreamCharacteristic = nullptr;

bool deviceConnected = false;

I2SClass I2S;

#define I2S_WS 44  // LRCK (yellow)
#define I2S_SCK 43 // BCLK (orange)
#define I2S_DIN 12 // Data In (SD)

// Audio buffer
char audioBuffer[256];  // Size depends on BLE MTU and latency

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
  if (!I2S.begin(I2S_MODE_STD, 44100, I2S_DATA_BIT_WIDTH_32BIT, I2S_SLOT_MODE_MONO)) {
    Serial.println("Failed to initialize I2S");
    while (true);
  }

  I2S.setPins(I2S_SCK, I2S_WS, -1, I2S_DIN);

  Serial.println("I2S initialized");
}

void setup() {
  Serial.begin(115200);
  delay(1000);
  InitBLE();
  InitI2S();
}

void loop() {
  size_t bytesRead = I2S.readBytes(audioBuffer, sizeof(audioBuffer));

  if (bytesRead == 0) {
    Serial.println("No data read from mic!");
  } else {
    Serial.print("Bytes read: ");
    Serial.println(bytesRead);
    for (int i = 0; i < 8; i++) {
      Serial.print((uint8_t)audioBuffer[i]);
      Serial.print(" ");
    }
     Serial.println();
  }

  Serial.println(pServer->getConnectedCount());
  if (deviceConnected) {
    // if (bytesRead > 0) {
    //   pAudioStreamCharacteristic->setValue(audioBuffer, bytesRead);
    //   pAudioStreamCharacteristic->notify();
    // }
  }

  delay(200); // Let BLE buffer breathe
}
