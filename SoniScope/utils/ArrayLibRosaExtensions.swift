//
//  ArrayLibRosaExtensions.swift
//  RosaKit
//
//  Created by Hrebeniuk Dmytro on 23.12.2019.
//  Copyright © 2019 Dmytro Hrebeniuk. All rights reserved.
//

import Foundation
import Accelerate
import PlainPocketFFT

public extension Array where Iterator.Element: FloatingPoint {
    
    static func createFFTFrequencies(sampleRate: Int, FTTCount: Int) -> [Element] {
        return [Element].linespace(start: 0, stop: Element(sampleRate)/Element(2), num: Element(1 + FTTCount/2))
    }
    
    static func createMELFrequencies(MELCount: Int, fmin: Element, fmax: Element) -> [Element] {
        let minMEL = Element.MEL(fromHZ: fmin)
        let maxMEL = Element.MEL(fromHZ: fmax)
        
        let mels = [Element].linespace(start: minMEL, stop: maxMEL, num: Element(MELCount))

        return mels.map { Element.HZ(fromMEL: $0) }
    }
    
    static func createMelFilter(sampleRate: Int, FTTCount: Int, melsCount: Int = 128) -> [[Element]] {
        let fmin = Element(0)
        let fmax = Element(sampleRate) / 2

        var weights = [Element].empty(width: melsCount, height: 1 + FTTCount/2, defaultValue: Element(0))

        let FFTFreqs = [Element].createFFTFrequencies(sampleRate: sampleRate, FTTCount: FTTCount)

        let MELFreqs = [Element].createMELFrequencies(MELCount: melsCount + 2, fmin: fmin, fmax: fmax)

        let diff = MELFreqs.diff
        
        let ramps = MELFreqs.outerSubstract(array: FFTFreqs)
        
        for index in 0..<melsCount {
            let lower = ramps[index].map { -$0 / diff[index] }
            let upper = ramps[index+2].map { $0 / diff[index+1] }
          
            weights[index] = [Element].minimumFlatVector(matrix1: lower, matrix2: upper).map { Swift.max(Element(0), $0) }
        }

        for index in 0..<melsCount {
            let enorm = Element(2) / (MELFreqs[index+2] - MELFreqs[index])
            weights[index] = weights[index].map { $0*enorm }
        }

        return weights
    }

    func powerToDB(ref: Element = Element(1), amin: Element = Element(1)/Element(Int64(10000000000.0)), topDB: Element = Element(80), maxVal: Element? = nil) -> [Element] {
        let ten = Element(10)
        let logSpec = self.map {ten * (Swift.max(amin, $0) / ref).logarithm10()}
        
        let maximum = maxVal ?? logSpec.max() ?? Element(0)
        print(maxVal, maximum)
        return logSpec.map { Swift.max($0, maximum - topDB) }
    }
}

public extension Array where Element == Double {
    
    func stft(nFFT: Int = 256, hopLength: Int = 1024) -> [[(real: Double, imagine: Double)]] {
        let FFTWindow = [Double].getHannWindow(frameLength: (nFFT)).map { [$0] }

        let centered = self.reflectPad(fftSize: nFFT)
        
        let yFrames = centered.frame(frameLength: nFFT, hopLength: hopLength)

        let matrix = FFTWindow.multiplyVector(matrix: yFrames)
                
        let rfftMatrix = matrix.rfft
                        
        let result = rfftMatrix
        
        return result
    }
        
    func melspectrogram(nFFT: Int = 2048, hopLength: Int = 512, sampleRate: Int = 22050, melsCount: Int = 128) -> [[Double]] {
        let spectrogram = self.stft(nFFT: nFFT, hopLength: hopLength)
            .map { $0.map { (pow($0.real, 2.0) + pow($0.imagine, 2.0)) } }
        let melBasis = [Double].createMelFilter(sampleRate: sampleRate, FTTCount: nFFT, melsCount: melsCount)
        return melBasis.dot(matrix: spectrogram)
    }

    func mfcc(nMFCC: Int = 20, nFFT: Int = 2048, hopLength: Int = 512, sampleRate: Int = 22050, melsCount: Int = 128) -> [[Double]] {
        let melSpectrogram = self.melspectrogram(nFFT: nFFT, hopLength: hopLength, sampleRate: sampleRate, melsCount: melsCount)
        
        let globalMax = melSpectrogram.flatMap { $0 }.max() ?? 1.0
        let globalMaxDb = 10 * log10(globalMax)
        let S = melSpectrogram.map { $0.powerToDB(maxVal: globalMaxDb) }
        
        print(S.flatMap{$0}.max(), S.flatMap{$0}.min())

        let floatMatrix = S.map { $0.map { Float($0) } }        
        let resultArray = self.computeDCT(matrix: floatMatrix, nCoeffs: nMFCC)
        
        return resultArray.map{ $0.map { Double($0) } }
    }


    func computeDCT(matrix: [[Float]], nCoeffs: Int) -> [[Float]] {
        let nMels = matrix.count
        let nFrames = matrix[0].count

        var mfccs = [[Float]](repeating: [Float](repeating: 0.0, count: nFrames), count: nCoeffs)
        
        let scale0: Float = sqrt(1.0 / Float(nMels))
        let scale: Float = sqrt(2.0 / Float(nMels))

        guard let dct = vDSP.DCT(count: nMels, transformType: .II) else {
            fatalError("Failed to create DCT setup")
        }

        for frameIndex in 0..<nFrames {
            let melFrame = (0..<nMels).map { matrix[$0][frameIndex] }
            var mfccFrame = [Float](repeating: 0.0, count: nMels)
            dct.transform(melFrame, result: &mfccFrame)
            for i in 0..<nCoeffs {
                let s = (i == 0) ? scale0 : scale
                mfccs[i][frameIndex] = mfccFrame[i] * s
            }
        }
        return mfccs
    }


}

extension Array where Element == [Double] {
    
    var rfft: [[(real: Double, imagine: Double)]] {
        let transposed = self.transposed
        let cols = transposed.count
        let rows = transposed.first?.count ?? 1
        let rfftRows = rows/2 + 1
        
        var flatMatrix = transposed.flatMap { $0 }
        let rfftCount = rfftRows*cols
        var resultComplexMatrix = [Double](repeating: 0.0, count: (rfftCount + cols + 1)*2)
                        
        resultComplexMatrix.withUnsafeMutableBytes { destinationData -> Void in
            let destinationDoubleData = destinationData.bindMemory(to: Double.self).baseAddress
            flatMatrix.withUnsafeMutableBytes { (flatData) -> Void in
                let sourceDoubleData = flatData.bindMemory(to: Double.self).baseAddress
                execute_real_forward(sourceDoubleData, destinationDoubleData, npy_intp(Int32(cols)), npy_intp(Int32(rows)), 1)
            }
        }

        var realMatrix = [Double](repeating: 0.0, count: rfftCount)
        var imagineMatrix = [Double](repeating: 0.0, count: rfftCount)

        for index in 0..<rfftCount {
            let real = resultComplexMatrix[index*2]
            let imagine = resultComplexMatrix[index*2+1]
            realMatrix[index] = real
            imagineMatrix[index] = imagine
        }
        
        let resultRealMatrix = realMatrix.chunked(into: rfftRows).transposed
        let resultImagineMatrix = imagineMatrix.chunked(into: rfftRows).transposed

        var result = [[(real: Double, imagine: Double)]]()
        for row in 0..<resultRealMatrix.count {
            let realMatrixRow = resultRealMatrix[row]
            let imagineMatrixRow = resultImagineMatrix[row]
            
            var resultRow = [(real: Double, imagine: Double)]()
            for col in 0..<realMatrixRow.count {
                resultRow.append((real: realMatrixRow[col], imagine: imagineMatrixRow[col]))
            }
            result.append(resultRow)
        }
        
        return result
    }
}
