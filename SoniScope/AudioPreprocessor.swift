//
//  AudioPreprocessor.swift
//  SoniScope
//
//  Created by Chiling Han on 7/15/25.
//


import Foundation
import AVFoundation
import Accelerate

class AudioPreprocessor {
    
    /// Loads an audio file, extracts MFCC + Mel features
    func extractFeatures(from url: URL) -> [Double]? {
        do {
            let file = try AVAudioFile(forReading: url)
            let format = file.processingFormat
            let frameCount = AVAudioFrameCount(file.length)
                        
            guard let originalBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                print("❌ Failed to allocate buffer")
                return nil
            }
            try file.read(into: originalBuffer)
            
            let audioSamples = convertToDoubleArray(buffer: originalBuffer)
            print(audioSamples.last)
            
            let nFFT = 2048
            let hopLength = 512
            let sampleRate = Int(format.sampleRate)
            let melsCount = 128

            let mfccs = audioSamples.mfcc(
                nMFCC: 40,
                nFFT: nFFT,
                hopLength: hopLength,
                sampleRate: sampleRate,
                melsCount: melsCount
            )
            let mel = audioSamples.melspectrogram(
                nFFT: nFFT,
                hopLength: hopLength,
                sampleRate: sampleRate,
                melsCount: melsCount
            )

            let mfccMean = mfccs.map { $0.mean() }
            let melMean = mel.map { $0.mean() }
            
            print(mfccMean)
            print(melMean)
            let combined = mfccMean + melMean  // Shape: [168]
            let input = combined // .map { [$0] }  // Shape: [[Double]] (168, 1)
            
            return input
            
        } catch {
            print("❌ Error reading audio file: \(error)")
            return nil
        }
    }
    
    /// Resamples a buffer to 22050Hz
    private func resampleTo22050Hz(_ inputBuffer: AVAudioPCMBuffer, from format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let targetSampleRate: Double = 22050.0
        
        guard let targetFormat = AVAudioFormat(commonFormat: format.commonFormat,
                                               sampleRate: targetSampleRate,
                                               channels: format.channelCount,
                                               interleaved: format.isInterleaved) else {
            print("❌ Failed to create target format.")
            return nil
        }
        
        guard let converter = AVAudioConverter(from: format, to: targetFormat) else {
            print("❌ Failed to create AVAudioConverter.")
            return nil
        }
        
        let ratio = targetSampleRate / format.sampleRate
        let newFrameCount = AVAudioFrameCount(Double(inputBuffer.frameLength) * ratio)
        
        guard let outputBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: newFrameCount) else {
            print("❌ Failed to create output buffer.")
            return nil
        }
        
        var error: NSError? = nil
        let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return inputBuffer
        }
        
        converter.convert(to: outputBuffer, error: &error, withInputFrom: inputBlock)
        
        if let error = error {
            print("❌ Conversion error: \(error)")
            return nil
        }
        
        outputBuffer.frameLength = newFrameCount
        return outputBuffer
    }
  
    /// Converts AVAudioPCMBuffer to [Double]
    private func convertToDoubleArray(buffer: AVAudioPCMBuffer) -> [Double] {
        guard let channelData = buffer.floatChannelData else { return [] }
        
        let frameLength = Int(buffer.frameLength)
        let channelCount = Int(buffer.format.channelCount)

        var mono = [Double](repeating: 0.0, count: frameLength)
        
        for c in 0..<channelCount {
            let channel = channelData[c]
            for i in 0..<frameLength {
                mono[i] += Double(channel[i])
            }
        }
        
        for i in 0..<frameLength {
            mono[i] /= Double(channelCount)
        }

        return mono
    }

}

extension Array where Element == Float {
    func mean() -> Float {
        guard !isEmpty else { return 0.0 }
        return reduce(0, +) / Float(self.count)
    }
}

extension Array where Element == Double {
    func mean() -> Double {
        guard !isEmpty else { return 0.0 }
        return reduce(0, +) / Double(self.count)
    }
}
