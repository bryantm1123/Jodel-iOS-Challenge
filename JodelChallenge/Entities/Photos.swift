//
//  Photos.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 30.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

struct Photos: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case pages
    }
    let currentPage: Int
    let pages: Int
    
    var photoDataList: [PhotoData]?
}
