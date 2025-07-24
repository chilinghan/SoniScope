//
//  SoniScopeApp.swift
//  SoniScope
//

import SwiftUI
import UIKit
import CoreData // ✅ REQUIRED for NSManagedObjectContext

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

    // ✅ Setup context first
    var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    // ✅ Properly initialize SessionManager using StateObject + wrappedValue
    @StateObject private var sessionManager = SessionManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
                .environmentObject(sessionManager)
        }
    }
}
