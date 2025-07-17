import Foundation

class BLEAudioWriter {
    private var fileHandle: FileHandle?
    private var totalBytesWritten: UInt32 = 0
    private var fileURL: URL?

    // WAV constants
    let sampleRate: UInt32 = 16000        // Match this with your Arduino sample rate
    let bitsPerSample: UInt16 = 16
    let numChannels: UInt16 = 1

    init() {
        setupFile()
    }

    private func setupFile() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let filename = "BLERecording_\(formatter.string(from: Date())).wav"
        fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        guard let fileURL = fileURL else { return }

        // Create file and write empty WAV header
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)
        guard let handle = try? FileHandle(forWritingTo: fileURL) else { return }

        self.fileHandle = handle
        self.totalBytesWritten = 0

        let header = generateWavHeader(dataSize: 0)
        fileHandle?.write(header)
    }

    func append(pcmData: Data) {
        fileHandle?.write(pcmData)
        totalBytesWritten += UInt32(pcmData.count)
    }

    func finishWriting() {
        guard let fileHandle = fileHandle, let fileURL = fileURL else { return }

        // Seek to beginning and write the real header
        let header = generateWavHeader(dataSize: totalBytesWritten)
        try? fileHandle.seek(toOffset: 0)
        fileHandle.write(header)
        try? fileHandle.close()

        print("✅ Saved WAV file at: \(fileURL.path)")
    }

    private func generateWavHeader(dataSize: UInt32) -> Data {
        let byteRate = sampleRate * UInt32(numChannels) * UInt32(bitsPerSample / 8)
        let blockAlign = UInt16(numChannels * (bitsPerSample / 8))
        let chunkSize = 36 + dataSize

        var header = Data()

        header.append("RIFF".data(using: .ascii)!)
        header.append(UInt32(chunkSize).littleEndianData)
        header.append("WAVE".data(using: .ascii)!)
        header.append("fmt ".data(using: .ascii)!)
        header.append(UInt32(16).littleEndianData)                      // Subchunk1Size
        header.append(UInt16(1).littleEndianData)                       // AudioFormat (1 = PCM)
        header.append(numChannels.littleEndianData)
        header.append(sampleRate.littleEndianData)
        header.append(byteRate.littleEndianData)
        header.append(blockAlign.littleEndianData)
        header.append(bitsPerSample.littleEndianData)
        header.append("data".data(using: .ascii)!)
        header.append(UInt32(dataSize).littleEndianData)

        return header
    }

    func getFileURL() -> URL? {
        return fileURL
    }
}

// MARK: - Helpers
extension FixedWidthInteger {
    var littleEndianData: Data {
        withUnsafeBytes(of: self.littleEndian, { Data($0) })
    }
}
