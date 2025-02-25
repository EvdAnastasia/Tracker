//
//  TrackersService.swift
//  Tracker
//
//  Created by Anastasiia on 04.01.2025.
//

import Foundation

protocol TrackersServiceDelegate: AnyObject {
    func reloadTrackers()
}

final class TrackersService {
    
    // MARK: - Public Properties
    static let shared = TrackersService()
    weak var delegate: TrackersServiceDelegate?
    
    var categoriesAmount: Int {
        let categories = fetchCategories()
        return categories.count
    }
    
    // MARK: - Private Properties
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private var trackerRecordStore = TrackerRecordStore.shared
    
    // MARK: - Initializers
    private init() {
        trackerCategoryStore.delegate = self
    }
    
    // MARK: - Public Methods
    func fetchCategories() -> [TrackerCategory] {
        trackerCategoryStore.fetchCategories()
    }
    
    func fetchRecords() -> [TrackerRecord] {
        trackerRecordStore.fetchRecords()
    }
    
    func addCategory(_ name: String) {
        trackerCategoryStore.addCategory(name)
    }
    
    func addTracker(_ tracker: Tracker, to category: String) {
        trackerCategoryStore.addTracker(tracker, to: category)
    }
    
    func updateTracker(_ tracker: Tracker, for category: String) {
        trackerCategoryStore.updateTracker(tracker, for: category)
    }
    
    func deleteTracker(_ tracker: Tracker, for category: String) {
        trackerCategoryStore.deleteTracker(tracker, for: category)
    }
    
    func addRecord(_ record: TrackerRecord) {
        trackerRecordStore.addRecord(record)
    }
    
    func deleteRecord(_ record: TrackerRecord) {
        trackerRecordStore.deleteRecord(record)
    }
}

extension TrackersService: TrackerCategoryStoreDelegate {
    func categoriesHaveChanged() {
        delegate?.reloadTrackers()
    }
}
