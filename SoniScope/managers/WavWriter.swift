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

        do {
            FileManager.default.createFile(atPath: fileURL.path, contents: nil)
            fileHandle = try FileHandle(forWritingTo: fileURL)

            writeWAVHeader()
        } catch {
            print("❌ Could not create WAV file: \(error)")
            return nil
        }
    }

    func writeWAVHeader() {
        var header = Data()

        header.append("RIFF".data(using: .ascii)!)
        header.append(UInt32(0).littleEndianData) // Placeholder for file size
        header.append("WAVE".data(using: .ascii)!)
        header.append("fmt ".data(using: .ascii)!)
        header.append(UInt32(16).littleEndianData) // Subchunk1Size (PCM)
        header.append(UInt16(1).littleEndianData)  // AudioFormat = PCM
        header.append(numChannels.littleEndianData)
        header.append(sampleRate.littleEndianData)
        let byteRate = sampleRate * UInt32(numChannels) * UInt32(bitsPerSample / 8)
        header.append(byteRate.littleEndianData)
        let blockAlign = UInt16(numChannels * bitsPerSample / 8)
        header.append(blockAlign.littleEndianData)
        header.append(bitsPerSample.littleEndianData)
        header.append("data".data(using: .ascii)!)
        header.append(UInt32(0).littleEndianData) // Placeholder for data chunk size

        fileHandle?.write(header)
    }

    func appendPCMData(_ data: Data) {
        print(data)
        fileHandle?.write(data)
        totalBytesWritten += UInt32(data.count)
    }

    func finalize() {
        guard let handle = try? FileHandle(forUpdating: fileURL) else { return }

        let fileSize = 36 + totalBytesWritten
        let dataChunkSize = totalBytesWritten

        try? handle.seek(toOffset: 4)
        handle.write(fileSize.littleEndianData)
        try? handle.seek(toOffset: 40)
        handle.write(dataChunkSize.littleEndianData)
        try? handle.close()
    }

    func getFileURL() -> URL {
        return fileURL
    }
}

private extension FixedWidthInteger {
    var littleEndianData: Data {
        withUnsafeBytes(of: self.littleEndian, { Data($0) })
    }
}
