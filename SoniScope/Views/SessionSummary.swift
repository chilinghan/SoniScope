import SwiftUI
import AVFoundation
import CoreData

struct Constants {
    static let ColorsBlue: Color = Color(red: 0, green: 0.53, blue: 1)
    static let FillsPrimary: Color = Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2)
}

struct SessionSummary: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    let session: SessionEntity

    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 24) {
                    // Header with back navigation
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(.chevron)
                                    .resizable()
                                    .frame(width: 24, height: 24)

                                Text(formattedMonth(session.timestamp))
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())

                        Spacer()

                        Text("Session Details")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)

                        Spacer()

                        HStack(spacing: 16) {
                            Text("Edit")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))

                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                                .offset(y:-3)
                        }
                    }
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text(session.name ?? "Untitled Session")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        Text(formattedDate(session.timestamp))
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))

                        Text("from 10:45 to 10:47")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Label(session.diagnosis ?? "Diagnosis Unknown", systemImage: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))

                        Text("This recording does not show signs of lung disease. SoniScope can not provide a formal diagnosis.")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recording")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)

                            Spacer()

                            Image(systemName: "waveform.circle")
                                .font(.system(size: 28))
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
                                .fill(Constants.FillsPrimary)
                                .frame(height: 6)

                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color(red: 0.99, green: 0.52, blue: 0),
                                            Color(red: 0.56, green: 0.79, blue: 0.9)
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * 0.4, height: 6)
                        }

                        HStack {
                            Button(action: playAudio) {
                                Image(systemName: "play.circle")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                            }

                            Spacer()

                            Image(systemName: "speaker.wave.2.circle")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color(red: 0.56, green: 0.79, blue: 0.9))
                        }
                    }
                    .padding()
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notes")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)

                        Text(session.notes ?? "Write notes here...")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.55, green: 0.55, blue: 0.58))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    Button(action: deleteSession) {
                        Text("Delete Session")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.99, green: 0.52, blue: 0))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.07, green: 0.07, blue: 0.07))
                            .cornerRadius(16)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 24)
                .padding(.bottom, 100)
            }
            .background(Color.black.ignoresSafeArea())
        }
        .navigationBarBackButtonHidden(true)
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }

    private func formattedMonth(_ date: Date?) -> String {
        guard let date = date else { return "Unknown" }
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL"
        return formatter.string(from: date)
    }

    private func playAudio() {
        guard let path = session.audioPath else {
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
        viewContext.delete(session)
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("⚠️ Failed to delete session: \(error)")
        }
    }
}
