//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Anastasiia on 19.01.2025.
//

import UIKit
import CoreData

private enum TrackerCategoryStoreError: Error {
    case decodingError
    case failedToFetchCategoryError
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func categoriesHaveChanged()
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    static let shared = TrackerCategoryStore()
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private Properties
    private let coreDataManager = CoreDataManager.shared
    private let trackerStore = TrackerStore.shared
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        do {
            try controller.performFetch()
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
        }
        return controller
    }()
    
    // MARK: - Initializers
    private override init() {}
    
    // MARK: - Public Methods
    func fetchCategories() -> [TrackerCategory] {
        guard let object = fetchedResultsController.fetchedObjects,
              let categories = try? object.map({ try convertCategory(from: $0)})
        else {
            return []
        }
        
        return categories
    }
    
    func fetchCategory(by name: String) throws -> TrackerCategoryCoreData? {
        fetchedResultsController.fetchedObjects?.first(where: {$0.title == name})
    }
    
    func addTracker(_ tracker: Tracker, to categoryName: String) {
        let trackerCategoryCoreData = try? fetchCategory(by: categoryName)
        
        guard let trackerCategoryCoreData else {
            return
        }
        
        trackerStore.addTracker(tracker, category: trackerCategoryCoreData)
    }
    
    func addCategory(_ name: String) {
        let category = fetchedResultsController.fetchedObjects?.first(where: {$0.title == name})
        if category == nil {
            let newCategory = TrackerCategoryCoreData(context: coreDataManager.context)
            newCategory.title = name
            newCategory.trackers = []
            coreDataManager.saveContext()
        }
    }
    
    // MARK: - Private Methods
    private func convertCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title,
              let trackersFromCoreData = trackerCategoryCoreData.trackers else {
            throw TrackerCategoryStoreError.decodingError
        }
        
        let trackers = try trackersFromCoreData.compactMap { tracker in
            guard let trackerCoreData = tracker as? TrackerCoreData else {
                throw TrackerCategoryStoreError.decodingError
            }
            
            do {
                let tracker = try trackerStore.convertTracker(from: trackerCoreData)
                return tracker
            } catch {
                print("\(error.localizedDescription)")
                return nil
            }
        }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.categoriesHaveChanged()
    }
}
