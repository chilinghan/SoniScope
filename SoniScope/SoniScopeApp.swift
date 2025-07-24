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
struct SoniScopeApp: App {

    // Connect AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isSignedIn") var isSignedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isSignedIn {
                ContentView()
            } else {
                ContentView()
                // LoginView()
            }
        }
    }
    
}
