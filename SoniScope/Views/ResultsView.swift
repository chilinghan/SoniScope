import SwiftUI
import AVFoundation
import CoreData
import PDFKit
import UIKit

struct ResultsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var healthManager: HealthDataManager

    var onFinish: () -> Void

    @State private var notesText: String = ""
    @State private var lastSavedNotes: String = ""
    @State private var audioPlayer: AVAudioPlayer?
    @FocusState private var notesFocused: Bool
    @StateObject private var keyboardResponder = KeyboardResponder()

    @State private var isSharing = false
    @State private var pdfURL: URL?
    @State private var audioFileURL: URL?

    private let saveTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .frame(height: geometry.safeAreaInsets.top + 50)
                    .edgesIgnoringSafeArea(.top)

                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    ZStack {
                        Text("Results")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        HStack {
                            Button(action: onFinish) {
                                HStack(spacing: 4) {
                                    Image(systemName: "chevron.left")
                                    Text("Home")
                                }
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                            }

                            Spacer()

                            Button(action: shareFiles) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                                    .offset(y: -5)
                            }
                        }
                    }
                    .padding(.top, geometry.safeAreaInsets.top + 4)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)

                    // Session Title
                    Text(sessionManager.currentSession?.name ?? "Untitled")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                        .cornerRadius(16)

                    // Diagnosis
                    VStack(alignment: .leading, spacing: 8) {
                        Label(sessionManager.currentSession?.diagnosis ?? "Unknown", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))

                        Text("This recording does not show signs of lung disease. SoniScope can not provide a formal diagnosis.")
                            .font(.system(size: 16))
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
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
                                .fill(LinearGradient(colors: [
                                    Color(red: 0.99, green: 0.52, blue: 0),
                                    Color(red: 0.56, green: 0.79, blue: 0.9)
                                ], startPoint: .leading, endPoint: .trailing))
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

                    // Notes
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        ZStack(alignment: .topLeading) {
                            if notesText.isEmpty {
                                Text("Add any notes or observations here...")
                                    .foregroundColor(Color.gray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 16)
                            }

                            TextEditor(text: $notesText)
                                .focused($notesFocused)
                                .scrollContentBackground(.hidden)
                                .padding(8)
                                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .multilineTextAlignment(.leading)
                                .frame(height: 100)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("Done") {
                                            notesFocused = false
                                        }
                                    }
                                }
                                .onReceive(saveTimer) { _ in
                                    autoSaveNotes()
                                }
                        }

                    }

                    // Delete Session
                    Button(action: deleteSession) {
                        Text("Delete Session")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                            .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, keyboardResponder.currentHeight)
                .animation(.easeInOut(duration: 0.25), value: keyboardResponder.currentHeight)
                .offset(y: keyboardResponder.currentHeight > 0 ? -keyboardResponder.currentHeight + 30 : -45)
            }
        }
        .onTapGesture {
            notesFocused = false
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            notesText = sessionManager.currentSession?.notes ?? ""
        }
        .sheet(isPresented: $isSharing) {
            if let pdf = pdfURL, let audio = audioFileURL {
                ShareSheet(activityItems: [pdf, audio])
            }
        }
        .background(Color.black.ignoresSafeArea())
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

    private func shareFiles() {
        guard let session = sessionManager.currentSession, let audioPath = session.audioPath else {
            print("⚠️ No audio path available")
            return
        }

        let audioURL = URL(fileURLWithPath: audioPath)

        if let pdf = PDFReportGenerator.generate(from: session, healthManager: healthManager) {
            self.audioFileURL = audioURL
            self.pdfURL = pdf
            self.isSharing = true
        }
    }
}
