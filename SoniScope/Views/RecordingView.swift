import SwiftUI

struct RecordingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var recordingTime: Int = 0
    @State private var isRecording = true
    @State private var isPulsing = false

    let totalRecordingTime = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var onNext: () -> Void // <--- Injected navigation closure

    var body: some View {
        ZStack {
            // Background Header
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

            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.clear)
                .frame(width: 402, height: 423)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: -10)
                .offset(y: 260)

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
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)

                Text(isRecording ? "Recording in Progress" : "Recording Complete")
                    .font(.system(size: 18, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
            }
            .offset(y: 310)

            // Instructions
            HStack{
                Text("Breathe normally and deeply. Maintain quiet environment during recording.")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            .padding(60)
            .offset(y: 200)


            // Divider
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 370, height: 1)
                .background(Color(red: 0.25, green: 0.25, blue: 0.27))
                .offset(y: 130)

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
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 32, height: 32)

                    Text("4")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .frame(width: 15, height: 34)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Text("Recording Session")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(60)
            .offset(y: 90)

            // Recording Indicator
            HStack(alignment: .top, spacing: 3) {
                Image(systemName: "circle.fill")
                    .font(.system(size: 12))
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
                    .foregroundColor(Color.gray)
            }
            .offset(y: -160)

            // Progress bar
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: 300, height: 6)
                    .foregroundColor(Color.gray.opacity(0.3))

                HStack {
                    LinearGradient(
                        colors: [
                            Color(red: 0.99, green: 0.52, blue: 0),
                            Color(red: 0.56, green: 0.79, blue: 0.9)
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

            // Timer
            Text(timeString(from: recordingTime))
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                .offset(x: 100, y: -240)
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
                    onNext() // <-- Trigger navigation callback
                }
            }
        }
    }

    private func timeString(from seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}
