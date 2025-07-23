//
//  RecordingViewer.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//


//
//  Recording.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/23/25.
//

import SwiftUI

struct RecordingViewer: View {
    @State private var progress: CGFloat = 0.0
    @State private var recordingTime: Int = 0
    @State private var isRecording = true
    @State private var isPulsing = false
    @State private var navigateToAnalyzing = false
    
    let totalRecordingTime = 20 // Total recording duration in seconds
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                // Background elements
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 482, height: 104)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .offset(y: -410)
                
                // Header
                ZStack {
                    Text("Session")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)

                    HStack(spacing: 3) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))

                        Text("End")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 50)
                .padding(.top, 10)
                .offset(y: -382)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 402, height: 423)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(30)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: -10)
                    .offset(y: 220)
                
                // Recording Button
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 351, height: 45)
                        .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0, y: 0.5),
                                endPoint: UnitPoint(x: 1, y: 0.5)
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    
                    Text(isRecording ? "Recording in Progress" : "Recording Complete")
                        .font(.system(size: 18, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }
                .offset(y: 325)
                
                // Instructions
                Text("Breathe normally and deeply. Maintain quiet environment during recording.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(60)
                    .offset(y: 150)
                
                // Divider
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 370, height: 1)
                    .background(Color(red: 0.25, green: 0.25, blue: 0.27))
                    .offset(y: 85)
                
                // Step indicator
                ZStack {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.56, green: 0.79, blue: 0.9), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.99, green: 0.52, blue: 0), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.17, y: 0.14),
                                    endPoint: UnitPoint(x: 0.84, y: 1)
                                )
                            )
                            .frame(width: 32, height: 32)
                        
                        Text("4")
                            .font(.system(size: 20, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .frame(width: 15, height: 34, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Recording Session")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(60)
                .offset(y: 50)
                
                // Recording indicator (animated)
                HStack(alignment: .top, spacing: 3) {
                    Image(systemName: "circle.fill")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 1, green: 0.22, blue: 0.24))
                        .opacity(isRecording ? 0.6 : 0.3)
                        .scaleEffect(isPulsing ? 1.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true),
                            value: isPulsing
                        )
                    
                    Text(isRecording ? "Recording lung sounds..." : "Recording complete")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                }
                .offset(y: -160)
                
                // Progress bar (animated)
                ZStack {
                    // Background track
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 300, height: 6)
                        .foregroundColor(Color.gray.opacity(0.3))
                    
                    // Foreground progress bar
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
                .offset(y: -200)
                
                // Timer (animated)
                Text(timeString(from: recordingTime))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                    .offset(x: 100, y: -240)
                
                // Invisible NavigationLink triggered by navigateToAnalyzing
                NavigationLink(
                    destination: Analyzing(),
                    isActive: $navigateToAnalyzing,
                    label: {
                        EmptyView()
                    }
                )
                .hidden()

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
                        navigateToAnalyzing = true
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
        .navigationBarBackButtonHidden(true)
    }
    
    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}


#Preview {
    RecordingViewer()
}
