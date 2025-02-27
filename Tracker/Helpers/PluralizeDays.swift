//
//  PluralizeDays.swift
//  Tracker
//
//  Created by Anastasiia on 17.02.2025.
//

import Foundation

final class PluralizeDays {
    static func convert(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        let text: String
        
        if remainder10 == 1 && remainder100 != 11 {
            text = NSLocalizedString("daysCount.one", comment: "One day text")
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 10 || remainder100 >= 20) {
            text = NSLocalizedString("daysCount.few", comment: "Few days text")
        } else {
            text = NSLocalizedString("daysCount.many", comment: "Many days text")
        }
        
        return "\(count) \(text)"
    }
}
