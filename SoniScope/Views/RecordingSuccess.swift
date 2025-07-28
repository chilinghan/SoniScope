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
                        session.audioPath = url.path // Save audio path
                        print("✅ Audio saved at: \(url.lastPathComponent)")

                        // Extract features and run model
                        Task {
                            let preprocessor = AudioPreprocessor()
                            if let features = try? preprocessor.extractFeatures(from: url),
                               let prediction = try? PredictionHelper.runModel(with: features) {
                                session.diagnosis = prediction
                                print("✅ Prediction: \(prediction)")
                            } else {
                                session.diagnosis = "Unknown"
                                print("❌ Failed to run model or extract features")
                            }

                            // 🔥 SAVE after modifying Core Data
                            do {
                                try sessionManager.context.save()
                                print("✅ Core Data saved with updated info")
                            } catch {
                                print("❌ Failed to save Core Data: \(error)")
                            }

                            onNext(session)
                        }
                    } else {
                        print("⚠️ No audio data or failed to save")
                    }
                } else {
                    print("❌ No current session available")
                }
            }
        }
    }
}
