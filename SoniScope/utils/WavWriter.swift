import Foundation

class WAVWriter {
    private var fileHandle: FileHandle?
    private var fileURL: URL

    let sampleRate: UInt32 = AudioConstants.sampleRate
    let numChannels: UInt16 = AudioConstants.channels
    let bitsPerSample: UInt16 = AudioConstants.bitsPerSample

    // 🆕 Use custom BandpassFilter instead of Accelerate
    private var bandpassFilter: BandpassFilter
    private var processedSamples: [Int16] = []


    init?(filename: String) {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        fileURL = docs.appendingPathComponent(filename)

        // Clean up existing file
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }

        FileManager.default.createFile(atPath: fileURL.path, contents: nil)

        // 🆕 Initialize your filter
        bandpassFilter = BandpassFilter(
            sampleRate: Double(sampleRate),
            lowCutoff: 100.0,
            highCutoff: 1500.0
            
        )
        
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
        header.append(UInt32(0).littleEndianData) // Placeholder for size
        header.append("WAVE".data(using: .ascii)!)
        header.append("fmt ".data(using: .ascii)!)
        header.append(UInt32(16).littleEndianData) // PCM format
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

    func appendPCMData(_ data: Data, vOFF: Int32 = 32768) {
        let sampleCount = data.count / 2
        var inputSamples = [Double](repeating: 0.0, count: sampleCount)

        data.withUnsafeBytes { ptr in
            for i in 0..<sampleCount {
                let offset = i * 2
                let sampleUInt16 = ptr.load(fromByteOffset: offset, as: UInt16.self)
                let signed = Int32(sampleUInt16) - vOFF
                inputSamples[i] = Double(signed)
            }
        }

        // Apply bandpass filter
        let filteredSamples = bandpassFilter.filter(input: inputSamples)

        // Apply gain and clamp
        for sample in filteredSamples {
            let clamped = Int16(max(min(sample, Double(Int16.max)), Double(Int16.min)))
            processedSamples.append(clamped)
        }
    }

    func finalize() {
        guard let handle = try? FileHandle(forUpdating: fileURL) else { return }

        // Calculate number of samples to trim based on 250ms
        let trimSamples = Int(Double(sampleRate) * 0.25)
        let totalSamples = processedSamples.count
        let startIndex = min(trimSamples, totalSamples)
        let endIndex = max(0, totalSamples - trimSamples)

        let trimmedSamples = Array(processedSamples[startIndex..<endIndex])

        // Prepare raw PCM data
        var outputData = Data(capacity: trimmedSamples.count * 2)
        for sample in trimmedSamples {
            let little = sample.littleEndian
            withUnsafeBytes(of: little) { outputData.append(contentsOf: $0) }
        }

        // Write WAV header and trimmed data
        try? handle.seek(toOffset: 44) // after WAV header
        handle.write(outputData)

        let dataChunkSize = UInt32(outputData.count)
        let fileSize = 36 + dataChunkSize

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
