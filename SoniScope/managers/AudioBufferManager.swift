//
//  AudioBufferManager.swift
//  SoniScope
//
//  Created by Chiling Han on 7/26/25.
//
import Foundation

class AudioBufferManager {
    private var buffer = Data()
    private let maxBufferSize: Int

    init(sampleRate: Int = AudioConstants.sampleRate, bytesPerSample: Int = AudioConstants.bitsPerSample / 8, channels: Int = AudioConstants.channels, durationSeconds: Int = 20) {
        self.maxBufferSize = sampleRate * bytesPerSample * channels * durationSeconds
    }

    func appendAudioData(_ data: Data) {
        print(data)
        buffer.append(data)
        if buffer.count > maxBufferSize {
            print("REMOVING DATA")
            // Remove oldest data to keep buffer size at max
            buffer.removeFirst(buffer.count - maxBufferSize)
        }
    }

    func getBuffer() -> Data {
        return buffer
    }

    func clearBuffer() {
        buffer.removeAll()
    }
}
