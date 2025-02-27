//
//  AnalyticsModel.swift
//  Tracker
//
//  Created by Anastasiia on 27.02.2025.
//

import Foundation

enum AnalyticsModel {
    enum Event: String {
        case open
        case click
        case close
    }
    
    enum Screen: String {
        case main
    }
    
    enum Item: String {
        case addTrack = "add_track"
        case track
        case filter
        case edit
        case delete
    }
}
