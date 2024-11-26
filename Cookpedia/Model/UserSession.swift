//
//  UserSession.swift
//  Cookpedia
//
//  Created by Bilal Dallali on 12/11/2024.
//

import Foundation
import SwiftData

@Model
class UserSession {
    
    @Attribute(.unique) var email: String
    var authToken: String
    var isRemembered: Bool
    
    init(email: String, authToken: String, isRemembered: Bool) {
        self.email = email
        self.authToken = authToken
        self.isRemembered = isRemembered
    }
}
