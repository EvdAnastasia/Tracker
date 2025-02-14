//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Anastasiia on 11.02.2025.
//

import Foundation

final class UserDefaultsService {
    // MARK: - Public Properties
    static let shared = UserDefaultsService()
    
    // MARK: - Private Properties
    private enum Keys: String {
        case hasCompletedOnboarding
    }
    private let storage = UserDefaults.standard
    
    private init() {}
}

extension UserDefaultsService: UserDefaultsServiceProtocol {
    var hasCompletedOnboarding: Bool {
        get {
            storage.bool(forKey: Keys.hasCompletedOnboarding.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.hasCompletedOnboarding.rawValue)
        }
    }
}
