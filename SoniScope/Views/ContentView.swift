//
//  ContentView.swift
//  SoniScope
//
//  Created by Chiling Han on 7/15/25.
//


import SwiftUI
import CoreML

public extension Color {
    static let soniscopeOrange = Color(red: 0.99, green: 0.52, blue: 0.0)
    static let soniscopeBlue = Color(red: 0.56, green: 0.79, blue: 0.9)
}

public struct AudioConstants {
    static let sampleRate: UInt32 = 16000
    static let channels: UInt16 = 1
    static let bitsPerSample: UInt16 = 16
}

struct ContentView: View {
    @EnvironmentObject var accessoryManager: AccessorySessionManager
    @EnvironmentObject var userManager: UserManager
    
    var body: some View {
        TabView {
            StartView()
                .tabItem {
                    Image(.orangelungs)
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24) // Custom size here
                    Text("Home")
                }
            
            ArchiveView()
                .tabItem {
                    Image(systemName: "archivebox")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                    Text("Archive")
                }
        }
        .tint(.soniscopeOrange)
    }
}

#Preview {
    ContentView()
        .environmentObject(AccessorySessionManager())
    
}
