//
//  PersistenceController.swift
//  SoniScope
//
//  Created by Venkata Siva Ramisetty on 7/24/25.
//


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "SessionModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error)")
            }
        }
    }
}
