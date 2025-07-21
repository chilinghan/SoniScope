//
//  DebugAudioSaverView.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/17/25.
//


import SwiftUI
import UIKit

struct DebugAudioSaverView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> DebugAudioSaverViewController {
        return DebugAudioSaverViewController()
    }

    func updateUIViewController(_ uiViewController: DebugAudioSaverViewController, context: Context) {}
}
