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

    init(sampleRate: Int = 44100, bytesPerSample: Int = 2, channels: Int = 1, durationSeconds: Int = 20) {
        self.maxBufferSize = sampleRate * bytesPerSample * channels * durationSeconds
    }

    func appendAudioData(_ data: Data) {
        buffer.append(data)
        if buffer.count > maxBufferSize {
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
