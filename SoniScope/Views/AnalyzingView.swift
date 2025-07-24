//
//  Analyzing.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//

import SwiftUI

struct AnalyzingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var recordingTime: Int = 0
    @State private var isRecording = true
    @State private var isPulsing = false
    @State private var navigateToSuccess = false

    let totalRecordingTime = 3 // Total analysis duration in seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var onNext: () -> Void // <--- Injected navigation closure

    var body: some View {
        NavigationView {
            ZStack {
                // Background bar
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 482, height: 104)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .offset(y: -400)

                // Header
                ZStack {
                    Text("Session")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                .offset(y: -370)

                // Progress bar
                ZStack {
                    // Background
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 300, height: 6)
                        .foregroundColor(Color.gray.opacity(0.3))

                    // Foreground
                    HStack {
                        LinearGradient(
                            stops: [
                                .init(color: Color(red: 0.99, green: 0.52, blue: 0), location: 0.00),
                                .init(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 1.00)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: 300 * progress, height: 6)
                        .cornerRadius(3)
                        .animation(.linear(duration: 1), value: progress)

                        Spacer()
                    }
                    .frame(width: 300, height: 6)
                }

                Text("Analyzing...")
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.53, green: 0.54, blue: 0.54))
                    .offset(y: -30)

            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            .background(Color.black)
            .onAppear {
                isPulsing = true
            }
            .onReceive(timer) { _ in
                if isRecording && recordingTime < totalRecordingTime {
                    recordingTime += 1
                    progress = CGFloat(recordingTime) / CGFloat(totalRecordingTime)

                    if recordingTime >= totalRecordingTime {
                        isRecording = false
                        isPulsing = false
                        navigateToSuccess = true
                        onNext()
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

