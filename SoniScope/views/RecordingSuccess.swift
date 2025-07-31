import SwiftUI

struct RecordingSuccess: View {
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var accessoryManager: AccessorySessionManager

    var onNext: () -> Void

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

                let nameParts = userManager.fetchUserNameParts()
                let firstName = nameParts.firstName ?? "User"
                let lastName = nameParts.lastName

                let fullName = lastName?.isEmpty == false ? "\(firstName) \(lastName!)" : firstName

                sessionManager.createAndSaveSession(name: fullName)

                if let session = sessionManager.currentSession {
                    if let url = savedURL {
                        session.audioPath = url.path // Save audio path
                        print("✅ Audio saved at: \(url.lastPathComponent)")

                        // Extract features and run model
                        Task {
                            let preprocessor = AudioPreprocessor()
                            if let features = preprocessor.extractFeatures(from: url) //Bundle.main.url(forResource: "144_1b1_Tc_sc_Meditron", withExtension: "wav")!),
                            {
                                let prediction = PredictionHelper.runModel(with: features)
                                session.diagnosis = prediction
                                print("✅ Prediction: \(prediction)")
                            } else {
                                session.diagnosis = "Unknown"
                                print("❌ Failed to run model or extract features")
                            }

                            do {
                                try sessionManager.context.save()
                                print("💾 Session changes saved")
                            } catch {
                                print("❌ Failed to save session changes: \(error)")
                            }
                            
                            onNext()
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
