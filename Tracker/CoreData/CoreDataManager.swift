//
//  CoreDataManager.swift
//  Tracker
//
//  Created by Anastasiia on 19.01.2025.
//

import CoreData

final class CoreDataManager {
    
    // MARK: - Public Properties
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unable to load persistent store: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initializers
    private init() {}
    
    // MARK: - Public Methods
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription)")
                context.rollback()
            }
        }
    }
}
