//
//  ContentView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/15/25.
//


import SwiftUI
import CoreML

struct ContentView: View {
    let processor = AudioPreprocessor()

    @State private var predictedLabel: String = "Waiting for prediction..."
    
    // Label map for your disease classes
    let labelMap: [Int: String] = [
        0: "COPD",
        1: "Healthy",
        2: "URTI",
        3: "Bronchiectasis",
        4: "Pneumonia",
        5: "Bronchiolitis",
        6: "Asthma",
        7: "LRTI"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Prediction Result")
                .font(.title)
                .bold()
            
            Text(predictedLabel)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Run Prediction") {
                if let url = Bundle.main.url(forResource: "116_1b2_Pl_sc_Meditron", withExtension: "wav") {
                    print("✅ Found audio file at: \(url)")

                    if let features = processor.extractFeatures(from: url) {
                        runModel(with: features)
                        print("🎯 Feature vector:\n", features)
                    } else {
                        print("❌ Feature extraction failed.")
                    }
                }

            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
    
    func runModel(with featureArray: [Double]) {
        guard featureArray.count == 168 else {
            predictedLabel = "Invalid feature array size"
            return
        }
        
        do {
            // Create MLMultiArray of shape [1, 168, 1]
            let mlArray = try MLMultiArray(shape: [1, 168, 1], dataType: .float32)
            for i in 0..<168 {
                mlArray[[NSNumber(value: 0), NSNumber(value: i), NSNumber(value: 0)]] =
                    NSNumber(value: featureArray[i])
            }
            
            // Replace 'LungDiseaseModel' with your model class name
            let model = try custom_model(configuration: MLModelConfiguration())
            let input = custom_modelInput(conv1d_input: mlArray) // Replace 'input_1' if needed
            let prediction = try model.prediction(input: input)
            
            // Get highest score index
            let index = argmax(prediction.Identity) // Replace 'output' with your actual output name
            let label = labelMap[index] ?? "Unknown"
            predictedLabel = "Predicted: \(label)"
            
        } catch {
            predictedLabel = "Prediction failed: \(error.localizedDescription)"
        }
    }
    
    // Helper: get index of largest value in MLMultiArray
    func argmax(_ array: MLMultiArray) -> Int {
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
