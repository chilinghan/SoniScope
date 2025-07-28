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

    /// Run Core ML model on feature array
    func runModel(with featureArray: [Double]) -> String {
        guard featureArray.count == 168 else {
            return "Invalid feature array size"
        }

        do {
            let mlArray = try MLMultiArray(shape: [1, 168, 1], dataType: .float32)
            for i in 0..<168 {
                mlArray[[0, i, 0] as [NSNumber]] = NSNumber(value: featureArray[i])
            }

            let model = try custom_model(configuration: MLModelConfiguration())
            let input = custom_modelInput(conv1d_input: mlArray)
            let prediction = try model.prediction(input: input)

            let index = argmax(prediction.Identity)
            let labelMap = [
                0: "COPD", 1: "Healthy", 2: "URTI",
                3: "Bronchiectasis", 4: "Pneumonia",
                5: "Bronchiolitis", 6: "Asthma", 7: "LRTI"
            ]
            return labelMap[index] ?? "Unknown"
        } catch {
            return "Prediction failed: \(error.localizedDescription)"
        }
    }

    /// Helper to get the index of the highest score
    func argmax(_ array: MLMultiArray) -> Int {
        var maxIndex = 0
        var maxValue = array[0].doubleValue
        for i in 1..<array.count {
            let val = array[i].doubleValue
            if val > maxValue {
                maxValue = val
                maxIndex = i
            }
        }
        return maxIndex
    }
    
    func saveSessionChanges() {
        do {
            try context.save()
            print("💾 Session changes saved")
        } catch {
            print("❌ Failed to save session changes: \(error)")
        }
    }

}
