//
//  UserSession.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 12/11/2024.
//

import Foundation
import SwiftData

@Model
final class UserSession {
    @Attribute(.unique) var userId: String
    var authToken: String
    var isRemembered: Bool = false
    
    init(userId: String, authToken: String, isRemembered: Bool) {
        self.userId = userId
        self.authToken = authToken
        self.isRemembered = isRemembered
    }
}
