//
//  SessionManager.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/24/25.
//

import Foundation
import CoreData
import CoreML

class SessionManager: ObservableObject {
    // Use the shared Core Data context
    let context = PersistenceController.shared.container.viewContext

    // Currently selected/active session
    @Published var currentSession: SessionEntity?

    /// Create and save a new session
    func createAndSaveSession(
        name: String,
        diagnosis: String = "No Audio Provided",
        audioPath: String = ""
    ) {
        let session = SessionEntity(context: context)
        session.id = UUID()
        session.name = name + " Session"
        session.audioPath = audioPath
        session.timestamp = Date()

        do {
            try context.save()
            currentSession = session
            print("✅ New session saved")
        } catch {
            print("❌ Failed to save session: \(error.localizedDescription)")
        }
    }

    /// Delete a session
    func deleteSession(_ session: SessionEntity) {
        context.delete(session)
        do {
            try context.save()
            print("🗑 Session deleted")
        } catch {
            print("❌ Failed to delete session: \(error.localizedDescription)")
        }
    }

    /// Fetch all saved sessions from Core Data
    func fetchAllSessions() -> [SessionEntity] {
        let request: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Failed to fetch sessions: \(error.localizedDescription)")
            return []
        }
    }
    
    func createFakeSession(
        diagnosis: String,
        name: String = "Chiling Han Session",
        date: Date
    ) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        guard let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) else {
            print("❌ Could not calculate end of day")
            return
        }

        // Check for existing session with same name on that date
        let request: NSFetchRequest<SessionEntity> = SessionEntity.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "diagnosis == %@", diagnosis),
            NSPredicate(format: "timestamp >= %@ AND timestamp < %@", startOfDay as NSDate, endOfDay as NSDate)
        ])

        do {
            let matches = try context.fetch(request)
            if !matches.isEmpty {
                print("⚠️ A session named '\(name)' already exists on that date. Skipping.")
                return
            }
        } catch {
            print("❌ Error checking for existing sessions: \(error)")
            return
        }

        // Create and save the new session
        let fakeSession = SessionEntity(context: context)
        fakeSession.id = UUID()
        fakeSession.name = name
        fakeSession.audioPath = Bundle.main.path(forResource: "115_1b1_Ar_sc_Meditron", ofType: "wav")
        fakeSession.diagnosis = diagnosis
        fakeSession.timestamp = date

        do {
            try context.save()
            print("💾 Session changes saved")
        } catch {
            print("❌ Failed to save session changes: \(error)")
        }
    }



}
