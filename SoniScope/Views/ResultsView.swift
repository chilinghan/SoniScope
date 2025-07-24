import SwiftUI
import AVFoundation
import CoreData

struct ResultsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sessionManager: SessionManager

    var onFinish: () -> Void

    @State private var notesText: String = ""
    @State private var lastSavedNotes: String = ""
    @State private var audioPlayer: AVAudioPlayer?

    private let saveTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    HStack {
                        Button(action: onFinish) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                Text("Home")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        }

                        Spacer()

                        Text("Results")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: {
                            // Share action
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                        }
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 10)

                    // Session Title
                    Text(sessionManager.currentSession?.name ?? "Untitled")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.leading)
                        .padding()
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(16)

                    // Diagnosis Box
                    VStack(alignment: .leading, spacing: 8) {
                        Label(
                            sessionManager.currentSession?.diagnosis ?? "Unknown",
                            systemImage: "checkmark.circle.fill"
                        )
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))

                        Text("This recording does not show signs of lung disease. SoniScope can not provide a formal diagnosis.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)

                    // Audio Playback
                    VStack(spacing: 12) {
                        HStack {
                            Text("Recording")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "waveform.circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        }

                        HStack {
                            Text("00:11")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                            Spacer()
                            Text("00:20")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.gray)
                        }

                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(red: 0.25, green: 0.25, blue: 0.27))
                                .frame(height: 6)

                            Capsule()
                                .fill(LinearGradient(
                                    colors: [Color(red: 0.99, green: 0.52, blue: 0), Color(red: 0.56, green: 0.79, blue: 0.9)],
                                    startPoint: .leading, endPoint: .trailing
                                ))
                                .frame(width: 145, height: 6)
                        }

                        HStack {
                            Button(action: playAudio) {
                                Image(systemName: "play.circle")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                            }

                            Spacer()

                            Image(systemName: "speaker.wave.2.circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        }
                    }
                    .padding()
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)

                    // Notes Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        TextEditor(text: $notesText)
                            .scrollContentBackground(.hidden)
                            .padding(8)
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(12)
                            .foregroundColor(.white)
                            .font(.system(size: 15))
                            .frame(height: 100)
                            .onReceive(saveTimer) { _ in
                                autoSaveNotes()
                            }
                    }

                    // Delete Button
                    Button(action: deleteSession) {
                        Text("Delete Session")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(16)
                    }

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 16)
            }
            .background(Color.black.ignoresSafeArea())
            .onAppear {
                notesText = sessionManager.currentSession?.notes ?? ""
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func autoSaveNotes() {
        guard let session = sessionManager.currentSession, notesText != lastSavedNotes else { return }
        session.notes = notesText
        do {
            try viewContext.save()
            lastSavedNotes = notesText
            print("✅ Notes auto-saved")
        } catch {
            print("⚠️ Auto-save failed: \(error)")
        }
    }

    private func playAudio() {
        guard let path = sessionManager.currentSession?.audioPath else {
            print("⚠️ No audio path saved")
            return
        }

        let fileURL = URL(fileURLWithPath: path)

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.play()
        } catch {
            print("⚠️ Could not play audio: \(error)")
        }
    }

    private func deleteSession() {
        guard let session = sessionManager.currentSession else { return }
        sessionManager.deleteSession(session)
        onFinish()
    }
}
