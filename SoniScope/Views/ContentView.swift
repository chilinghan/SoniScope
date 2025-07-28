//
//  ContentView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/15/25.
//


import SwiftUI
import CoreML

public extension Color {
    static let soniscopeOrange = Color(red: 0.99, green: 0.52, blue: 0.0)
    static let soniscopeBlue = Color(red: 0.56, green: 0.79, blue: 0.9)
}

public struct AudioConstants {
    static let sampleRate: UInt32 = 8000
    static let channels: UInt16 = 1
    static let bitsPerSample: UInt16 = 16
}

struct ContentView: View {
    let processor = AudioPreprocessor()

    @State private var predictedLabel: String = "Waiting for prediction..."
    @EnvironmentObject var accessoryManager: AccessorySessionManager
    
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
        TabView {
            StartView()
                .tabItem {
                    Image(.orangelungs)
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24) // Custom size here
                    Text("Home")
                }

            ArchiveView()
                .tabItem {
                    Image(systemName: "archivebox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Archive")
                }
        }
        .tint(.soniscopeOrange)
            
            // Custom tab bar overlaid at the bottom
//            VStack(spacing: 6) {
//                HStack(spacing: 80) {
//                    tabItem(image: .orangelungs, label: "Home", tab: .home)
//                    tabItem(image: .archive, label: "Archive", tab: .archive)
//                }
//            }
//            .frame(width: UIScreen.main.bounds.size.width, height: 77)
//            .cornerRadius(16)
//            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
//            .padding(.horizontal, 16)
//            .padding(.bottom, 0)
        
        
//        VStack(spacing: 20) {
//            Text("Prediction Result")
//                .font(.title)
//                .bold()
//            
//            Text(predictedLabel)
//                .font(.title2)
//                .multilineTextAlignment(.center)
//                .padding()
//            
//            Button("Run Prediction") {
//                if let url = Bundle.main.url(forResource: "144_1b1_Tc_sc_Meditron", withExtension: "wav") {
//                    print("✅ Found audio file at: \(url)")
//
//                    if let features = processor.extractFeatures(from: url) {
//                        runModel(with: features)
//                        print("🎯 Feature vector:\n", features)
//                    } else {
//                        print("❌ Feature extraction failed.")
//                    }
//                }
//
//            }
//            .padding()
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//        }
//        .padding()
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
            print(prediction.Identity)
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

#Preview {
    ContentView()
        .environmentObject(AccessorySessionManager())
    
}
