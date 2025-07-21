import UIKit
import AVFoundation

class DebugAudioSaverViewController: UIViewController {

    var player: AVAudioPlayer?
    var fileURL: URL?

    let playButton = UIButton(type: .system)
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()

        // 1. Generate and Save PCM → WAV
        let sampleRate = 16000
        let durationSeconds = 2
        let frequency = 440.0
        let pcmData = generateSineWavePCM(frequency: frequency, sampleRate: sampleRate, duration: durationSeconds)

        if let savedURL = AudioSaver.shared.savePCMAsWav(pcmData: pcmData, sampleRate: sampleRate, channels: 1) {
            self.fileURL = savedURL
            label.text = "Saved: \(savedURL.lastPathComponent)"
        } else {
            label.text = "Error saving file"
        }
    }

    func generateSineWavePCM(frequency: Double, sampleRate: Int, duration: Int) -> Data {
        var pcmBuffer = Data()
        let sampleCount = sampleRate * duration
        for i in 0..<sampleCount {
            let t = Double(i) / Double(sampleRate)
            let amplitude = Int16(32767 * sin(2.0 * .pi * frequency * t))
            pcmBuffer.append(contentsOf: withUnsafeBytes(of: amplitude.littleEndian, Array.init))
        }
        return pcmBuffer
    }

    func setupUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)

        playButton.setTitle("▶️ Play Audio", for: .normal)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playAudio), for: .touchUpInside)
        view.addSubview(playButton)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            playButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc func playAudio() {
        guard let url = fileURL else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("❌ Playback error: \(error)")
        }
    }
}
