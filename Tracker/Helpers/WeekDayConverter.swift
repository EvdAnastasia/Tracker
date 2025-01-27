//
//  WeekDaysConverter.swift
//  Tracker
//
//  Created by Anastasiia on 20.01.2025.
//

import Foundation

final class WeekDaysConverter {
    func convertToArray(from weekDays: String) -> [WeekDay] {
        return weekDays.components(separatedBy: ",").compactMap{ WeekDay(rawValue: Int($0) ?? 0) }
    }
    
    func convertToString(from weekDays: [WeekDay]) -> String {
        weekDays.map{ String($0.rawValue) }.joined(separator: ",")
    }
}
