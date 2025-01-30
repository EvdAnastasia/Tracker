//
//  TrackerStyleSections.swift
//  Tracker
//
//  Created by Anastasiia on 15.01.2025.
//

import Foundation

enum TrackerStyleSections: Int, CaseIterable {
    case emoji = 0
    case colors = 1
    
    func getHeaderName() -> String {
        switch self {
        case .emoji:
            "Emoji"
        case .colors:
            "Цвет"
        }
    }
}
