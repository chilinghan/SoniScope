import Foundation

class WAVWriter {
    private var fileHandle: FileHandle?
    private var fileURL: URL
    private var totalBytesWritten: UInt32 = 0

    let sampleRate: UInt32 = AudioConstants.sampleRate
    let numChannels: UInt16 = AudioConstants.channels
    let bitsPerSample: UInt16 = AudioConstants.bitsPerSample
    let duration: UInt16 = 20

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
        
        let wavSampleSize = UInt32(duration) * ((sampleRate * (UInt32(bitsPerSample) / 8)) * UInt32(numChannels))

        header.append("RIFF".data(using: .ascii)!)
        header.append((wavSampleSize + 44 - 8).littleEndianData) // Placeholder for file size
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
        header.append(UInt32(wavSampleSize).littleEndianData) // Placeholder for data chunk size

        fileHandle?.write(header)
    }

    func appendPCMData(_ data: Data, vOFF: Int32 = 15000) {
        let sampleCount = data.count / 2
        var signedSamples = Data(capacity: data.count)
        
        for i in 0..<sampleCount {
            let offset = i * 2
            
            // Read unsigned 16-bit sample (little endian)
            let sampleUInt16 = data.withUnsafeBytes { ptr -> UInt16 in
                ptr.load(fromByteOffset: offset, as: UInt16.self)
            }
            
            // Convert UInt16 back to signed Int32 (undo sender scaling if needed)
            // The sender clamps to [0,30000], so unsigned range is limited here
            
            // Convert unsigned sample to signed by removing offset vOFF
            let rawSigned = Int32(sampleUInt16) - vOFF
            
            // Optional: scale back if you want, since sender shifted right by 14 bits (means original scale was >>14)
            // But usually just playback the signed samples
            
            // Clamp to Int16 range for playback
            let clamped = min(max(rawSigned, Int32(Int16.min)), Int32(Int16.max))
            let signedSample = Int16(clamped)
            
            // Append little endian bytes of signedSample to output
            var sampleLE = signedSample.littleEndian
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
