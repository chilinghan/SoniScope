//
//  Analyzing.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//

import SwiftUI

struct AnalyzingView: View {
    @EnvironmentObject var accessoryManager: AccessorySessionManager
    
    @State private var progress: CGFloat = 0.0
    @State private var recordingTime: Int = 0
    @State private var isRecording = true

    let totalRecordingTime = 3 // Total analysis duration in seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var onNext: () -> Void // <--- Injected navigation closure

    var body: some View {
        VStack {
            Spacer()

            VStack {
                Text("Analyzing...")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.53, green: 0.54, blue: 0.54))
                    .padding(.bottom, 30)
                
                // Progress bar
                ProgressBar(progress: progress)
            }
            
            Spacer()

        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
        .background(.black)
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            if isRecording && recordingTime < totalRecordingTime {
                recordingTime += 1
                progress = CGFloat(recordingTime) / CGFloat(totalRecordingTime)

                if recordingTime >= totalRecordingTime {
                    isRecording = false
                    onNext()
                }
            }
        }
    }
}

#Preview {
    AnalyzingView(onNext: {})
}
