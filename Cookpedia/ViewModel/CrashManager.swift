//
//  CrashManager.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 22/03/2025.
//

import Foundation
import FirebaseCrashlytics

// Handle crashmanager
final class CrashManager {
    static let shared = CrashManager()
    
    private init() {}
    
    func setUserId(userId: String) {
        Crashlytics.crashlytics().setUserID(userId)
    }
    
    func setValue(value: String, key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
    
    func addLog(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}
