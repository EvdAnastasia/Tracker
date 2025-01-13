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
    var trackers: [TrackerCategory] = TrackersServiceMockData.trackers
    
    // MARK: - Initializers
    private init() { }
    
    // MARK: - Public Methods
    func addTracker(tracker: Tracker, for category: String) {
        if let categoryIndex = trackers.firstIndex(where: { $0.title == category }) {
            let currentCategory = trackers[categoryIndex]
            let newCategory = TrackerCategory(title: currentCategory.title,
                                              trackers: currentCategory.trackers + [tracker])
            
            trackers[categoryIndex] = newCategory
        }
        
        delegate?.reloadTrackers()
    }
}
