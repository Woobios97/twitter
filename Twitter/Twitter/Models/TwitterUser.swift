//
//  TwitterUser.swift
//  Twitter
//
//  Created by 김우섭 on 10/16/23.
//

import Foundation
import Firebase

struct TwitterUser: Codable {
    let id: String
    var displayName: String = ""
    var username: String = ""
    var followersCount: Double = 0
    var followingCount: Double = 0
    var createdOn: Date = Date()
    var bio: String = ""
    var avavatarPath: String = ""
    var isUserOnboarded: Bool = false
    
    init(from user: User) {
        self.id = user.uid
    }
}
