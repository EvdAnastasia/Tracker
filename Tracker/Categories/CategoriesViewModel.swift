//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Anastasiia on 12.02.2025.
//

import Foundation

typealias Binding<T> = (T) -> ()

final class CategoriesViewModel {
    
    // MARK: - Public Properties
    var categoriesBinding: Binding<[TrackerCategory]>?
    var categoriesAmount: Int {
        trackersService.categoriesAmount
    }
    var selectedCategory: String?
    
    // MARK: - Private Properties
    private let trackersService = TrackersService.shared
    private(set) var categories: [TrackerCategory] = [] {
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    // MARK: - Public Methods
    func fetchCategories() {
        categories = trackersService.fetchCategories()
    }
    
    func addCategory(_ category: String) {
        trackersService.addCategory(category)
    }
    
    func getCategoryName(at index: Int) -> String? {
        guard index < categories.count else { return nil }
        return categories[index].title
    }
}
