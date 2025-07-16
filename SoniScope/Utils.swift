import Foundation
import Accelerate

// Helper: Create Hann window
func hannWindow(size: Int) -> [Float] {
    var window = [Float](repeating: 0, count: size)
    vDSP_hann_window(&window, vDSP_Length(size), Int32(vDSP_HANN_NORM))
    return window
}

// Pad signal with zeros on both sides for center=True
func padSignalCenter(signal: [Float], nFFT: Int) -> [Float] {
    let padSize = nFFT / 2
    let padding = [Float](repeating: 0, count: padSize)
    return padding + signal + padding
}

// STFT Magnitude with automatic center=True padding
func stftMagnitude(signal: [Float], nFFT: Int, hopLength: Int) -> [[Float]] {
    let paddedSignal = padSignalCenter(signal: signal, nFFT: nFFT)
    let window = hannWindow(size: nFFT)
    let signalLength = paddedSignal.count
    let frameCount = 1 + (signalLength - nFFT) / hopLength
    
    var spectrogram = [[Float]]()
    
    guard let fftSetup = vDSP_create_fftsetup(vDSP_Length(log2(Float(nFFT))), FFTRadix(kFFTRadix2)) else {
        fatalError("Failed to create FFT setup")
    }
    
    for frame in 0..<frameCount {
        let start = frame * hopLength
        let frameSignal = Array(paddedSignal[start..<start+nFFT])
        
        // Window the frame
        var windowedSignal = [Float](repeating: 0, count: nFFT)
        vDSP_vmul(frameSignal, 1, window, 1, &windowedSignal, 1, vDSP_Length(nFFT))
        
        // Prepare complex buffer
        var realp = windowedSignal
        var imagp = [Float](repeating: 0, count: nFFT)
        var splitComplex = DSPSplitComplex(realp: &realp, imagp: &imagp)
        
        // Perform FFT
        vDSP_fft_zip(fftSetup, &splitComplex, 1, vDSP_Length(log2(Float(nFFT))), FFTDirection(FFT_FORWARD))
        
        // Calculate magnitudes (sqrt(real^2 + imag^2))
        var magnitudes = [Float](repeating: 0, count: nFFT / 2 + 1)
        magnitudes[0] = abs(realp[0])  // DC component
        for i in 1..<(nFFT/2) {
            magnitudes[i] = sqrt(realp[i]*realp[i] + imagp[i]*imagp[i])
        }
        magnitudes[nFFT/2] = abs(realp[nFFT/2])  // Nyquist
        
        spectrogram.append(magnitudes)
    }
    
    vDSP_destroy_fftsetup(fftSetup)
    
    return spectrogram  // shape: frames x (nFFT/2 +1)
}

// Mel filter bank (same as before)
func melFilterBank(sampleRate: Float, nFFT: Int, nMels: Int, fMin: Float = 0, fMax: Float? = nil) -> [[Float]] {
    let fMaxVal = fMax ?? sampleRate / 2
    let fftFreqs = (0...nFFT/2).map { Float($0) * sampleRate / Float(nFFT) }
    
    func hzToMel(_ hz: Float) -> Float {
        return 2595 * log10(1 + hz / 700)
    }
    func melToHz(_ mel: Float) -> Float {
        return 700 * (pow(10, mel / 2595) - 1)
    }
    
    let melMin = hzToMel(fMin)
    let melMax = hzToMel(fMaxVal)
    let melPoints = (0...nMels+2).map { i in
        melMin + (melMax - melMin) * Float(i) / Float(nMels + 2)
    }
    let hzPoints = melPoints.map { melToHz($0) }
    
    var filterBank = [[Float]](repeating: [Float](repeating: 0, count: nFFT/2 + 1), count: nMels)
    
    for m in 0..<nMels {
        let f_m_minus = hzPoints[m]
        let f_m = hzPoints[m+1]
        let f_m_plus = hzPoints[m+2]
        
        for k in 0..<fftFreqs.count {
            let freq = fftFreqs[k]
            if freq >= f_m_minus && freq <= f_m {
                filterBank[m][k] = (freq - f_m_minus) / (f_m - f_m_minus)
            } else if freq >= f_m && freq <= f_m_plus {
                filterBank[m][k] = (f_m_plus - freq) / (f_m_plus - f_m)
            } else {
                filterBank[m][k] = 0
            }
        }
    }
    
    return filterBank  // nMels x freqBins
}

// Mel spectrogram (with padding inside STFT)
func melSpectrogram(signal: [Float], sampleRate: Float, nFFT: Int = 2048, hopLength: Int = 512, nMels: Int = 128) -> [[Float]] {
    let spectrogram = stftMagnitude(signal: signal, nFFT: nFFT, hopLength: hopLength)  // frames x freqBins
    
    let melFilter = melFilterBank(sampleRate: sampleRate, nFFT: nFFT, nMels: nMels)
    
    let freqBins = nFFT/2 + 1
    let frames = spectrogram.count
    
    // Transpose spectrogram to freqBins x frames
    var spectrogramT = [[Float]](repeating: [Float](repeating: 0, count: frames), count: freqBins)
    for i in 0..<frames {
        for j in 0..<freqBins {
            spectrogramT[j][i] = spectrogram[i][j]
        }
    }
    
    var melSpec = [[Float]](repeating: [Float](repeating: 0, count: frames), count: nMels)
    
    for m in 0..<nMels {
        for f in 0..<freqBins {
            let filterVal = melFilter[m][f]
            if filterVal == 0 { continue }
            for t in 0..<frames {
                melSpec[m][t] += filterVal * spectrogramT[f][t]
            }
        }
    }
    
    // Transpose back to frames x nMels
    var melSpecT = [[Float]](repeating: [Float](repeating: 0, count: nMels), count: frames)
    for t in 0..<frames {
        for m in 0..<nMels {
            melSpecT[t][m] = melSpec[m][t]
        }
    }
    
    return melSpecT
}
