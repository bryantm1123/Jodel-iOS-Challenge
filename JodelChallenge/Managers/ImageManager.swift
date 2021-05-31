//
//  ImageManager.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 28.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

class ImageManager: IManager {
    
    private let flickrService: FlickrService
    
    init(flickrService: FlickrService = FlickrService()) {
        self.flickrService = flickrService
    }
    
    func getPhotos(page: Int = 1, completion: @escaping (_ photos: Photos?, _ error: Error?) -> Void) {
        
        flickrService.getPhotos(page: page) { photos, error in
            if let photos = photos {
                completion(photos, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
