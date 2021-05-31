//
//  FlickrService.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 28.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

class FlickrService {
    
    private var flickr: FlickrKit
    private let apiKey = "92111faaf0ac50706da05a1df2e85d82"
    private let secret = "89ded1035d7ceb3a"
    private let perPage = "20"
    
    init(flickr: FlickrKit = FlickrKit.shared()) {
        self.flickr = flickr
    }
    
    func getPhotos(page: Int = 1, completion: @escaping (_ photos: Photos?, _ error: Error?) -> Void) {
        
        flickr.initialize(withAPIKey: apiKey, sharedSecret: secret)
        
        let interesting = FKFlickrInterestingnessGetList()
        interesting.per_page = perPage
        interesting.page = String(page)
        
        flickr.call(interesting) { response, error in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if let response = response,
                   let topPhotos = response["photos"] as? [String: AnyObject],
                   let photoArray = topPhotos["photo"] as? [[String: AnyObject]] {
                    
                    do {
                        let data = try JSONSerialization.data(withJSONObject: topPhotos, options: [])
                        var photos = try JSONDecoder().decode(Photos.self, from: data)
                        
                        var photoDataList = [PhotoData]()
                        for photoData in photoArray {
                            let thumbnailURL = self.getThumbnailURL(data: photoData)
                            let imageURL = self.getImageURL(data: photoData)
                            let imageTitle = self.getImageTitle(data: photoData)
                            let photoData = PhotoData(thumbnailURL: thumbnailURL, imageURL: imageURL, title: imageTitle)
                            photoDataList.append(photoData)
                        }
                        photos.photoDataList = photoDataList
                        completion(photos, nil)
                    } catch {
                        completion(nil, error)
                    }
                } else {
                    completion(nil, error)
                }
            }
        }
    }
    
    func getThumbnailURL(data: [String: AnyObject]) -> URL {
        return flickr.photoURL(for: .thumbnail100, fromPhotoDictionary: data)
    }
    
    func getImageURL(data: [String: AnyObject]) -> URL {
        return flickr.photoURL(for: .medium800, fromPhotoDictionary: data)
    }
    
    func getImageTitle(data: [String: AnyObject]) -> String? {
        return data["title"] as? String
    }
}
