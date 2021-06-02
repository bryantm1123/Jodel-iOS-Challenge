//
//  PhotoResponse.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/21/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

// MARK: - PhotoResponse
struct PhotoResponse: Codable {
    let photos: Photos
    let extra: Extra
    let stat: String
}

// MARK: - Extra
struct Extra: Codable {
    let exploreDate: String
    let nextPreludeInterval: Int

    enum CodingKeys: String, CodingKey {
        case exploreDate = "explore_date"
        case nextPreludeInterval = "next_prelude_interval"
    }
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let isPublic, isFriend, isFamily: Int
    
    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server,
             farm, title,
             isPublic = "ispublic",
             isFriend = "isfriend",
             isFamily = "isfamily"
    }
}
