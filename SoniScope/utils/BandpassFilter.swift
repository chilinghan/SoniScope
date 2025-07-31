//
//  BandpassFilter.swift
//  SoniScope
//
//  Created by Chiling Han on 7/30/25.
//


class BandpassFilter {
    let sampleRate: Double
    let lowCutoff: Double
    let highCutoff: Double

    // States
    private var lowPassPrev: Double = 0.0
    private var highPassPrevInput: Double = 0.0
    private var highPassPrevOutput: Double = 0.0

    // Alphas
    private let lowPassAlpha: Double
    private let highPassAlpha: Double

    init(sampleRate: Double, lowCutoff: Double, highCutoff: Double) {
        self.sampleRate = sampleRate
        self.lowCutoff = lowCutoff
        self.highCutoff = highCutoff

        // Calculate smoothing factors
        self.lowPassAlpha = (2 * Double.pi * highCutoff) / (2 * Double.pi * highCutoff + sampleRate)
        self.highPassAlpha = sampleRate / (2 * Double.pi * lowCutoff + sampleRate)
    }

    func filter(input: [Double]) -> [Double] {
        var output = [Double](repeating: 0.0, count: input.count)

        for i in 0..<input.count {
            // High-pass filter (first order)
            let hp = highPassAlpha * (highPassPrevOutput + input[i] - highPassPrevInput)
            highPassPrevInput = input[i]
            highPassPrevOutput = hp

            // Low-pass filter (first order)
            lowPassPrev = lowPassAlpha * hp + (1 - lowPassAlpha) * lowPassPrev

            output[i] = lowPassPrev
        }

        return output
    }
}
