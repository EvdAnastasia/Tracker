//
//  AppMetricaService.swift
//  Tracker
//
//  Created by Anastasiia on 27.02.2025.
//

import Foundation
import AppMetricaCore

final class AppMetricaService {
    
    static func activate() {
        let configuration = AppMetricaConfiguration(apiKey: AppMetricaServiceConstants.apiKey)
        AppMetrica.activate(with: configuration!)
    }
    
    static func reportEvent(
        name: AnalyticsModel.Name,
        event: AnalyticsModel.Event,
        screen: AnalyticsModel.Screen,
        item: AnalyticsModel.Item? = nil
    ) {
        var parameters: [String: Any] = ["event": event.rawValue, "screen": screen.rawValue]
        
        if let item {
            parameters["item"] = item.rawValue
        }
        
        AppMetrica.reportEvent(name: name.rawValue, parameters: parameters, onFailure: { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
