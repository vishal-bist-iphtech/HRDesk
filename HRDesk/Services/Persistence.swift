//
//  Persistence.swift
//  HRDesk
//
//  Created by iPHTech 34 on 07/08/26.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    // temperary database for previews
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "HRDesk")

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        let coordinator = container.persistentStoreCoordinator

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {

                print(
                    "Failed to load persistent store:",
                    error,
                    error.userInfo
                )

                // Corrupt or incompatible store: discard it and recreate,otherwise the app would crash on every launch.
                if let storeURL = storeDescription.url {

                    try? FileManager.default.removeItem(at: storeURL)
                    try? FileManager.default.removeItem(
                        at: URL(fileURLWithPath: storeURL.path + "-shm")
                    )
                    try? FileManager.default.removeItem(
                        at: URL(fileURLWithPath: storeURL.path + "-wal")
                    )

                    do {
                        try coordinator.addPersistentStore(
                            ofType: NSSQLiteStoreType,
                            configurationName: nil,
                            at: storeURL,
                            options: nil
                        )
                    } catch {
                        let nsError = error as NSError
                        fatalError(
                            "Failed to recreate persistent store \(nsError), \(nsError.userInfo)"
                        )
                    }

                } else {

                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }

            guard !inMemory else {return}
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
