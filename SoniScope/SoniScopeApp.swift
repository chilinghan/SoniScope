//
//  SoniScopeApp.swift
//  SoniScope
//

import SwiftUI
import UIKit
import CoreData

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

@main
struct SoniScopeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isSignedIn") var isSignedIn: Bool = false

    let persistenceController = PersistenceController.shared

    var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    // ✅ SessionManager and HealthDataManager must both be StateObjects
    @StateObject private var sessionManager = SessionManager()
    @StateObject private var healthManager = HealthDataManager() // ✅ Added this line

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
                .environmentObject(sessionManager)
                .environmentObject(healthManager) // ✅ Now initialized properly
                .preferredColorScheme(.dark)

        }
    }
}
