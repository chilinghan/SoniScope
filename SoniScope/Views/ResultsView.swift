import SwiftUI
import AVFoundation
import CoreData
import PDFKit
import UIKit

struct ResultsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var sessionManager: SessionManager
    @EnvironmentObject var healthManager: HealthDataManager

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SessionEntity.timestamp, ascending: false)],
        animation: .default
    ) private var allSessions: FetchedResults<SessionEntity>

    var session: SessionEntity

    @State private var audioPlayer: AVAudioPlayer?
    @State private var isSharing = false
    @State private var pdfURL: URL?
    @State private var audioFileURL: URL?

    @State private var audioDuration: TimeInterval = 0
    @State private var currentTime: TimeInterval = 0
    @State private var isPlaying: Bool = false
    @State private var timer: Timer? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Session Header
                HStack {
                    Text(session.name ?? "Untitled")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                .cornerRadius(16)

                // Diagnosis
                VStack(alignment: .leading, spacing: 8) {
                    Label(session.diagnosis ?? "Unknown", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)

                    Text("This recording does not show signs of lung disease. SoniScope cannot provide a formal diagnosis.")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
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
                        Text(formatTime(currentTime))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(formatTime(audioDuration))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                    }

                    ProgressBar(progress: CGFloat(currentTime / max(audioDuration, 0.01)))

                    HStack {
                        Button(action: playAudio) {
                            Image(systemName: isPlaying ? "pause.circle" : "play.circle")
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
            }
            .padding(24)
        }
        .background(Color.black)
        .navigationBarBackButtonHidden()
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Back Button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        .font(.system(size: 20, weight: .semibold))
                }
            }

            // Share Button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shareFiles()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .sheet(isPresented: $isSharing) {
            if let url = pdfURL {
                ShareSheet(activityItems: [url, audioFileURL].compactMap { $0 })
            }
        }
    }

    private func playAudio() {
        guard let path = session.audioPath else {
            print("⚠️ No audio path saved")
            return
        }

        let fileURL = URL(fileURLWithPath: path)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = 1.0  // Ensure volume is max

            audioDuration = audioPlayer?.duration ?? 0
            audioPlayer?.play()
            isPlaying = true

            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                guard let player = audioPlayer else { return }
                currentTime = player.currentTime
                if !player.isPlaying {
                    timer?.invalidate()
                    isPlaying = false
                }
            }
        } catch {
            print("⚠️ Could not play audio: \(error)")
        }
    }


    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func deleteSession() {
        sessionManager.deleteSession(session)
        dismiss()
    }

    private func shareFiles() {
        guard let audioPath = session.audioPath else {
            print("⚠️ No audio path available")
            return
        }

        let audioURL = URL(fileURLWithPath: audioPath)
        let sessionsArray = Array(allSessions)

        if let pdf = PDFReportGenerator.generate(from: sessionsArray, healthManager: healthManager) {
            self.audioFileURL = audioURL
            self.pdfURL = pdf
            self.isSharing = true
        } else {
            print("❌ PDF generation failed")
        }
    }
}

// MARK: - ShareSheet
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
