//
//  SessionManager.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/24/25.
//

import Foundation
import CoreData

class SessionManager: ObservableObject {
    // Use the shared Core Data context
    let context = PersistenceController.shared.container.viewContext

    // Currently selected/active session
    @Published var currentSession: SessionEntity?

    /// Create and save a new session
    func createAndSaveSession(
        name: String = "Untitled",
        diagnosis: String = "",
        audioPath: String = "",
    ) {
        let session = SessionEntity(context: context)
        session.id = UUID()
        session.name = name
        session.diagnosis = diagnosis
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
}
