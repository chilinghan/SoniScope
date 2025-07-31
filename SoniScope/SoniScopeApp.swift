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
    @State private var isLoggedIn: Bool = false
    
    let persistenceController = PersistenceController.shared

    var context: NSManagedObjectContext {
        persistenceController.container.viewContext
    }

    // ✅ SessionManager and HealthDataManager must both be StateObjects
    @StateObject private var sessionManager = SessionManager()
    @StateObject private var userManager = UserManager()
    @StateObject private var healthManager = HealthDataManager()
    @StateObject private var accessoryManager = AccessorySessionManager()

    var body: some Scene {
            
        WindowGroup {
            if !isLoggedIn {
                LoginView(isLoggedIn: $isLoggedIn)
                    .environmentObject(userManager)
            }
            else {
                ContentView()
                    .environment(\.managedObjectContext, context)
                    .environmentObject(sessionManager)
                    .environmentObject(healthManager)
                    .environmentObject(accessoryManager)
                    .environmentObject(userManager)
                    .preferredColorScheme(.dark)
                    .onAppear {
                        sessionManager.createFakeSession(diagnosis: "COPD", date: Calendar.current.date(from: DateComponents(year: 2025, month: 7, day: 1))!)
                        sessionManager.createFakeSession(diagnosis: "URTI", date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30))!)
                        sessionManager.createFakeSession(diagnosis: "Bronchiectasis", date: Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30))!)
                    }
            }


        }
    }
}



