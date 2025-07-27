import Foundation

class AudioSaver {
    static let shared = AudioSaver()

    func savePCMAsWav(pcmData: Data, sampleRate: Int = AudioConstants.sampleRate, bitsPerSample: Int = AudioConstants.bitsPerSample, channels: Int = AudioConstants.channels) -> URL? {
        let byteRate = sampleRate * channels * bitsPerSample / 8
        let blockAlign = channels * bitsPerSample / 8
        let dataSize = pcmData.count
        let chunkSize = 36 + dataSize

        var header = Data()

        header.append("RIFF".data(using: .ascii)!)
        header.append(UInt32(chunkSize).littleEndianData)
        header.append("WAVE".data(using: .ascii)!)
        header.append("fmt ".data(using: .ascii)!)
        header.append(UInt32(16).littleEndianData)
        header.append(UInt16(1).littleEndianData) // PCM
        header.append(UInt16(channels).littleEndianData)
        header.append(UInt32(sampleRate).littleEndianData)
        header.append(UInt32(byteRate).littleEndianData)
        header.append(UInt16(blockAlign).littleEndianData)
        header.append(UInt16(bitsPerSample).littleEndianData)
        header.append("data".data(using: .ascii)!)
        header.append(UInt32(dataSize).littleEndianData)

        let wavData = header + pcmData

        let filename = "soniscope-\(Self.timestamp()).wav"
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(filename)

        do {
            try wavData.write(to: fileURL)
            return fileURL
        } catch {
            print("❌ Failed to write WAV: \(error)")
            return nil
        }
    }

    private static func timestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmss"
        return formatter.string(from: Date())
    }
}

private extension FixedWidthInteger {
    var littleEndianData: Data {
        withUnsafeBytes(of: self.littleEndian, { Data($0) })
    }
}
