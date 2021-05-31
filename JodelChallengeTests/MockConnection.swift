//
//  MocConnection.swift
//  JodelChallengeTests
//
//  Created by Grigor Grigoryan on 30.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation
@testable import JodelChallenge

class Mock: IManager {
    
    var networkState: NetworkState = .success
    let flickerService: FlickrService = FlickrService()
    
    func getPhotos(page: Int, completion: @escaping (Photos?, Error?) -> Void) {
        
        switch networkState {
        case .success:
            onFetchSuccess(page: page, completion: completion)
        case .fail:
            completion(nil, nil)
        case .delayed:
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.onFetchSuccess(page: page, completion: completion)
            }
        }
    }
    
    func onFetchSuccess(page: Int, completion: @escaping (Photos?, Error?) -> Void) {
        let testBundle = Bundle(for: type(of: self))
        let filePath = testBundle.path(forResource: "Stub", ofType: "json")
        
        if let path = filePath {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) else {
                completion(nil, nil)
                return
            }
            let jsonResult = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
            
            if let response = jsonResult,
               let topPhotos = response["photos"] as? [String: AnyObject],
               let photoArray = topPhotos["photo"] as? [[String: AnyObject]],
               let decoded = try? JSONSerialization.data(withJSONObject: topPhotos, options: []) {
                var blogPost: Photos? = try? JSONDecoder().decode(Photos.self, from: decoded)
                
                var photos = [PhotoData]()
                for photoData in photoArray {
                    let thumbnailURL = flickerService.getThumbnailURL(data: photoData)
                    let imageURL = flickerService.getImageURL(data: photoData)
                    let imageTitle = flickerService.getImageTitle(data: photoData)
                    let photo = PhotoData(thumbnailURL: thumbnailURL, imageURL: imageURL, title: imageTitle)
                    photos.append(photo)
                }
                blogPost?.photoDataList = photos
                completion(blogPost, nil)
            }
        }
    }
}
