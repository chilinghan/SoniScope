//
//  PredictionHelper.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/26/25.
//


import CoreML

class PredictionHelper {
    static let labelMap: [Int: String] = [
        0: "COPD",
        1: "Healthy",
        2: "URTI",
        3: "Bronchiectasis",
        4: "Pneumonia",
        5: "Bronchiolitis",
        6: "Asthma",
        7: "LRTI"
    ]

    static func runModel(with features: [Double]) -> String {
        guard features.count == 168 else {
            return "Invalid input shape"
        }

        do {
            let mlArray = try MLMultiArray(shape: [1, 168, 1], dataType: .float32)
            for i in 0..<168 {
                mlArray[[0, i, 0] as [NSNumber]] = NSNumber(value: features[i])
            }

            let model = try soniscope2(configuration: MLModelConfiguration())
            let input = soniscope2Input(conv1d_15_input: mlArray)
            let prediction = try model.prediction(input: input)

            let index = argmax(prediction.Identity)
            return labelMap[index] ?? "Unknown"

        } catch {
            return "Model error: \(error.localizedDescription)"
        }
    }

    private static func argmax(_ array: MLMultiArray) -> Int {
        var maxIndex = 0
        var maxValue = array[0].doubleValue
        for i in 1..<array.count {
            let val = array[i].doubleValue
            if val > maxValue {
                maxValue = val
                maxIndex = i
            }
        }
        return maxIndex
    }
}
