//
//  AudioPreprocessor.swift
//  SoniScope
//
//  Created by Chiling Han on 7/15/25.
//


import Foundation
import AVFoundation
import Accelerate
import RosaKit

class AudioPreprocessor {
    
    /// Loads an audio file, resamples to 22050Hz, extracts MFCC + Mel features
    func extractFeatures(from url: URL) -> [[Double]]? {
        do {
            let file = try AVAudioFile(forReading: url)
            let format = file.processingFormat
            let frameCount = AVAudioFrameCount(file.length)
                        
            guard let originalBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                print("❌ Failed to allocate buffer")
                return nil
            }
            try file.read(into: originalBuffer)
            
            guard let resampledBuffer = resampleTo22050Hz(originalBuffer, from: format) else {
                print("❌ Failed to resample.")
                return nil
            }
            let audioSamples = convertToDoubleArray(buffer: resampledBuffer)
//            print(audioSamples.last)
            
            let nFFT = 2048
            let hopLength = 512
            let sampleRate = 22050
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
            print(mfccs)

            let mfccMean = mfccs.map { $0.mean() }
            let melMean = mel.map { $0.mean() }
            
            print(mfccMean)
            print(melMean)
            let combined = mfccMean + melMean  // Shape: [168]
            let input = combined.map { [$0] }  // Shape: [[Double]] (168, 1)
            
            return input
            
        } catch {
            print("❌ Error reading audio file: \(error)")
            return nil
        }
    }
    
    /// Resamples a buffer to 22050Hz
    private func resampleTo22050Hz(_ inputBuffer: AVAudioPCMBuffer, from format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let targetSampleRate: Double = 22050.0
        
        guard let targetFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                               sampleRate: targetSampleRate,
                                               channels: format.channelCount,
                                               interleaved: false) else {
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
    
    /// Converts AVAudioPCMBuffer to [Float]
    private func convertToFloatArray(buffer: AVAudioPCMBuffer) -> [Float] {
        let channelData = buffer.floatChannelData![0]
        let frameLength = Int(buffer.frameLength)
        return (0..<frameLength).map { Float(channelData[$0]) }
    }
    
    /// Converts AVAudioPCMBuffer to [Double]
    private func convertToDoubleArray(buffer: AVAudioPCMBuffer) -> [Double] {
        let channelData = buffer.floatChannelData![0]
        let frameLength = Int(buffer.frameLength)
        return (0..<frameLength).map { Double(channelData[$0]) }
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
