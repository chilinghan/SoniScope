#include "ESP_I2S.h"

I2SClass i2s;

void setup() {
  Serial.begin(115200);
  while (!Serial) { } // wait for Serial port to open (if needed)

  // Configure I2S pins and settings (adjust pins to your hardware)
  i2s.setPins(43, 44, -1, 12); // BCLK, LRCLK, DOUT pins
  i2s.setTimeout(1000);

  i2s.begin(I2S_MODE_STD, 16000, I2S_DATA_BIT_WIDTH_32BIT, I2S_SLOT_MODE_MONO, I2S_STD_SLOT_LEFT);  // 16kHz, 16-bit, mono

  Serial.println("Starting WAV recording...");
  
  size_t wavSize = 0;
  uint8_t* wavData = i2s.recordWAV(5, &wavSize);  // record 5 seconds WAV
  
  Serial.println(wavSize);
  if (wavData && wavSize > 0) {
    Serial.printf("Recorded %d bytes. Sending data...\n", wavSize);

    // Send a marker so you know when file starts (optional)
    Serial.println("===WAV_START===");

    // Write raw WAV bytes over Serial
    Serial.write(wavData, wavSize);
    Serial.flush();  // wait until all bytes sent

    // End marker
    Serial.println("\n===WAV_END===");
  } else {
    Serial.println("Recording failed or no data.");
  }

  // free wavData if necessary (depends on library internals)
  // delete[] wavData; // uncomment if dynamically allocated
}

void loop() {
  // nothing to do
}
