//
//  Tweet.swift
//  Twitter
//
//  Created by 김우섭 on 10/21/23.
//

import Foundation

struct Tweet: Codable, Identifiable {
    var id = UUID().uuidString
    let author: TwitterUser
    let authorID: String
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
