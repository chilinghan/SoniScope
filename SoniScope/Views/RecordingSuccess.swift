import SwiftUI

struct RecordingSuccess: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var accessoryManager: AccessorySessionManager

    var onNext: (SessionEntity) -> Void

    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "checkmark.circle")
                .font(.system(size: 96, weight: .light))
                .foregroundColor(.soniscopeBlue)
                .padding(10)

            Text("Recording\nComplete")
                .font(.system(size: 37, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.soniscopeBlue)
            Spacer()
        }
        .navigationTitle("Session")
        .navigationBarTitleDisplayMode(.inline)
        .background(.black)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let savedURL = accessoryManager.getSavedWAVFileURL()

                accessoryManager.sendScreenCommand("complete")
                accessoryManager.stopRecordingToWAV()

                sessionManager.createAndSaveSession()

                if let session = sessionManager.currentSession {
                    if let url = savedURL {
                        session.audioPath = url.path // Use `.path` not `.absoluteString` for local files
                        print("✅ Audio saved at: \(url.lastPathComponent)")

                        Task {
                            let preprocessor = AudioPreprocessor()
                            do {
                                guard let features = try preprocessor.extractFeatures(from: url) else {
                                    print("❌ Failed to extract features from audio")
                                    onNext(session)
                                    return
                                }

                                let prediction = try PredictionHelper.runModel(with: features)
                                session.diagnosis = prediction
                                print("✅ ML Prediction: \(prediction)")
                                onNext(session)
                            } catch {
                                print("❌ Error during model prediction: \(error.localizedDescription)")
                                onNext(session)
                            }
                        }
                    } else {
                        print("⚠️ No audio data or failed to save")
                        onNext(session)
                    }
                } else {
                    print("❌ No current session available")
                }
            }
        }
    }
}
