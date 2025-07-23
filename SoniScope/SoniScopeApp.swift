//
//  SoniScopeApp.swift
//  SoniScope
//
//  Created by Chiling Han on 7/14/25.
//

import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

@main
struct YourApp: App {
    @StateObject var sessionStore = SessionStore()

    // Connect AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            HealthProfileView()
//            AudioSaverView()
//                .edgesIgnoringSafeArea(.all)
//            PairingView()
//            ArchiveView().environmentObject(sessionStore)
            HomeView()
            
        }
    }
}
