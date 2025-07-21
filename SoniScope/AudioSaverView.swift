//
//  DebugAudioSaverView.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/17/25.
//


import SwiftUI
import UIKit

struct AudioSaverView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AudioSaverViewController {
        return AudioSaverViewController()
    }

    func updateUIViewController(_ uiViewController: AudioSaverViewController, context: Context) {}
}
