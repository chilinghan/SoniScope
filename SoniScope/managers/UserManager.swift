//
//  UserManager.swift
//  SoniScope
//
//  Created by Chiling Han on 7/28/25.
//

import Foundation
import CoreData
import CoreML

class UserManager: ObservableObject {
    // Use the shared Core Data context
    let context = PersistenceController.shared.container.viewContext

    /// Create and save a new session
    func saveUserName(
        firstname: String = "User",
        lastname: String = ""
    ) {
        let user = UserEntity(context: context)
        user.firstname = firstname
        user.lastname = lastname

        do {
            try context.save()
            print("✅ New user saved")
        } catch {
            print("❌ Failed to save user: \(error.localizedDescription)")
        }
    }

    /// Fetch all saved sessions from Core Data
    func fetchUserNameParts() -> (firstName: String?, lastName: String?) {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.fetchLimit = 1

        do {
            if let user = try context.fetch(request).first {
                return (user.firstname, user.lastname)
            }
        } catch {
            print("❌ Failed to fetch user: \(error)")
        }

        return (nil, nil)
    }
    
}
