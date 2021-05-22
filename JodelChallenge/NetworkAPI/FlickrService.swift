//
//  FlickrService.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/21/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation


class FlickrService {
    
    let engine: PhotoEngine
    var flickrInteresting = FKFlickrInterestingnessGetList()
    
    init(_ engine: PhotoEngine = FlickrKit.shared()) {
        self.engine = engine
    }
    
    func fetchPhotos(for count: String) {
        flickrInteresting.per_page = count
        FlickrKit.shared().call(flickrInteresting) { (response, error) -> Void in
            DispatchQueue.main.async {
                print(response)
            }
        }
    }
}

extension FlickrKit: PhotoEngine {
    func fetchPhotos(count: String, completion: @escaping Handler) {
        
    }
}

protocol PhotoEngine {
    func fetchPhotos(count: String, completion: @escaping Handler)
}

typealias Handler = ([URL], Error) -> Void
