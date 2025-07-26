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
    
    var session: SessionEntity
    
    @State private var audioPlayer: AVAudioPlayer?
    
    @State private var isSharing = false
    @State private var pdfURL: URL?
    @State private var audioFileURL: URL?
    
    private let saveTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    @State private var audioDuration: TimeInterval = 0
    @State private var currentTime: TimeInterval = 0
    @State private var isPlaying: Bool = false
    @State private var timer: Timer? = nil
    
    var body: some View {
        ScrollView {
            VStack (spacing: 30) {
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
                    
                    Text("This recording does not show signs of lung disease. SoniScope can not provide a formal diagnosis.")
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
                    
                    // Time Display
                    HStack {
                        Text(formatTime(currentTime))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(formatTime(audioDuration))
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    
                    // Progress Bar
                    ProgressBar(progress: CGFloat(currentTime / max(audioDuration, 0.01)))
                    
                    // Playback Controls
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
            .sheet(isPresented: $isSharing) {
                if let pdf = pdfURL, let audio = audioFileURL {
                    ShareSheet(activityItems: [pdf, audio])
                }
            }
            .padding(24)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Results")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Leading button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                    print("Settings tapped")
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        .font(.system(size: 20, weight: .semibold))
                }
            }

            // Trailing button
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shareFiles()
                    print("Notifications tapped")
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                        .font(.system(size: 20, weight: .semibold))
                }
            }
        }
        .background(.black)
}

    private func playAudio() {
        guard let path = session.audioPath else {
            print("⚠️ No audio path saved")
            return
        }

        let fileURL = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioDuration = audioPlayer?.duration ?? 0
            audioPlayer?.play()
            isPlaying = true

            // Start timer to update progress
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

        if let pdf = PDFReportGenerator.generate(from: session, healthManager: healthManager) {
            self.audioFileURL = audioURL
            self.pdfURL = pdf
            self.isSharing = true
        }
    }
}
