//
//  PhotosPresentationLogic.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/23/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

protocol PhotosPresentationLogic {
    var photoService: FlickrService? { get }
    var photoModels: [PhotoTuple] { get }
    
    func fetchPhotos()
}
