//
//  AnalyticsManager.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 19/03/2025.
//

import Foundation
import FirebaseAnalytics

// Handle the analytics manager
final class AnalyticsManager {
    static let shared = AnalyticsManager()
    
    private init() {}
    
    func logEvent(name: String, params: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
    
    func setUserId(userId: String) {
        Analytics.setUserID(userId)
    }
    
    func setUserProperty(value: String?, property: String) {
        Analytics.setUserProperty(value, forName: property)
    }
}
