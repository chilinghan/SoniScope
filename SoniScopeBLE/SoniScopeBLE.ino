#include <ArduinoBLE.h>

// BLE Service and Characteristic
BLEService audioService("180A"); 
BLECharacteristic audioChar("2A57", BLERead | BLENotify, 20);

void setup() {
  Serial.begin(9600);
  while (!Serial);

  if (!BLE.begin()) {
    Serial.println("BLE init failed!");
    while (1);
  }

  // Setup BLE
  BLE.setLocalName("SoniScope");
  BLE.setAdvertisedService(audioService);
  audioService.addCharacteristic(audioChar);
  BLE.addService(audioService);
  
  // Start advertising
  BLE.advertise();
  Serial.println("BLE Ready - Waiting for connections...");
}

void loop() {
  BLEDevice central = BLE.central();
  
  if (central) {
    Serial.print("Connected to: ");
    Serial.println(central.address());

    while (central.connected()) {
      // Create sample audio data (replace with real sensor data)
      int16_t sample = analogRead(A0); // Example using analog input
      byte audioData[2] = {
        highByte(sample), 
        lowByte(sample)
      };
      
      // Send data
      audioChar.writeValue(audioData, sizeof(audioData));
      delay(100); // Send 10x per second
    }

    Serial.println("Disconnected");
  }
}