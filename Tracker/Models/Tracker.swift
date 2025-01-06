//
//  Tracker.swift
//  Tracker
//
//  Created by Anastasiia on 07.12.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let title: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]
    let isHabit: Bool
}
