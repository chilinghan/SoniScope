import Foundation

class WAVWriter {
    private var fileHandle: FileHandle?
    private var fileURL: URL
    private var totalBytesWritten: UInt32 = 0

    let sampleRate: UInt32 = AudioConstants.sampleRate
    let numChannels: UInt16 = AudioConstants.channels
    let bitsPerSample: UInt16 = AudioConstants.bitsPerSample

    init?(filename: String) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = docs.appendingPathComponent(filename)

        // Remove existing file if it exists
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }

        FileManager.default.createFile(atPath: fileURL.path, contents: nil)

        do {
            fileHandle = try FileHandle(forWritingTo: fileURL)
            writeWAVHeader()
        } catch {
            print("❌ Could not create WAV file: \(error)")
            return nil
        }
    }

    private func writeWAVHeader() {
        var header = Data()

        header.append("RIFF".data(using: .ascii)!)
        header.append(UInt32(0).littleEndianData) // Placeholder for final file size
        header.append("WAVE".data(using: .ascii)!)
        header.append("fmt ".data(using: .ascii)!)
        header.append(UInt32(16).littleEndianData) // PCM header size
        header.append(UInt16(1).littleEndianData)  // AudioFormat = PCM
        header.append(numChannels.littleEndianData)
        header.append(sampleRate.littleEndianData)

        let byteRate = sampleRate * UInt32(numChannels) * UInt32(bitsPerSample / 8)
        let blockAlign = UInt16(numChannels * bitsPerSample / 8)

        header.append(byteRate.littleEndianData)
        header.append(blockAlign.littleEndianData)
        header.append(bitsPerSample.littleEndianData)

        header.append("data".data(using: .ascii)!)
        header.append(UInt32(0).littleEndianData) // Placeholder for data size

        fileHandle?.write(header)
    }

    func appendPCMData(_ data: Data, vOFF: Int32 = 15000) {
        let sampleCount = data.count / 2
        var signedSamples = Data(capacity: data.count)

        for i in 0..<sampleCount {
            let offset = i * 2
            let sampleUInt16 = data.withUnsafeBytes { ptr -> UInt16 in
                ptr.load(fromByteOffset: offset, as: UInt16.self)
            }

            let rawSigned = Int32(sampleUInt16) - vOFF
            let clamped = min(max(rawSigned, Int32(Int16.min)), Int32(Int16.max))
            var sampleLE = Int16(clamped).littleEndian

            withUnsafeBytes(of: &sampleLE) { bytes in
                signedSamples.append(contentsOf: bytes)
            }
        }

        fileHandle?.write(signedSamples)
        totalBytesWritten += UInt32(signedSamples.count)
    }

    func finalize() {
        guard let handle = try? FileHandle(forUpdating: fileURL) else { return }

        let fileSize = 36 + totalBytesWritten
        let dataChunkSize = totalBytesWritten

        do {
            try handle.seek(toOffset: 4)
            handle.write(fileSize.littleEndianData)

            try handle.seek(toOffset: 40)
            handle.write(dataChunkSize.littleEndianData)

            try handle.close()
        } catch {
            print("❌ Failed to finalize WAV file: \(error)")
        }

        fileHandle = nil
    }

    func getFileURL() -> URL {
        return fileURL
    }
}

private extension FixedWidthInteger {
    var littleEndianData: Data {
        withUnsafeBytes(of: self.littleEndian) { Data($0) }
    }
}
