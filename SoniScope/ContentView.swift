//
//  ContentView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/14/25.
//

import SwiftUI

struct ContentView: View {
    let processor = AudioPreprocessor()

    var body: some View {
        Text("Extracting audio features...")
            .onAppear {
                if let url = Bundle.main.url(forResource: "111_1b2_Tc_sc_Meditron", withExtension: "wav")
                {
                    print("✅ Found audio file at: \(url)")

                    if let features = processor.extractFeatures(from: url) {
                        print("🎯 Feature vector:\n", features)
                    } else {
                        print("❌ Feature extraction failed.")
                    }
                }
            }
    }
}
#Preview {
    ContentView()
}
