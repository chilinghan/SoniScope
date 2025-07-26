import SwiftUI

struct RecordingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var recordingTime: Int = 0
    @State private var isRecording = true
    @State private var isPulsing = false

    let totalRecordingTime = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var onNext: () -> Void = {} // <--- Injected navigation closure

    var body: some View {
        VStack {
            // Timer
            HStack {
                Spacer()
                
                Text(timeString(from: recordingTime))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
            }
            .padding(.horizontal, 60)
            
            // Progress bar
            ProgressBar(progress: progress)
            
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
            .padding(.top, 20)
        }
        .background(.black)
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
                    onNext()
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

#Preview {
    RecordingView()
}
