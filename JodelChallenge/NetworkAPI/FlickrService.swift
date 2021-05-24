//
//  FlickrService.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/21/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation


/// A service to interact with FlickrKit and fetch photos from the Flickr API
class FlickrService {
    
    private let engine: PhotoEngine
    var flickrInteresting = FKFlickrInterestingnessGetList()
    
    init(_ engine: PhotoEngine = FlickrKit.shared()) {
        self.engine = engine
    }
    
    
    /// Fetches photos from the Flickr API
    /// - Parameters:
    ///   - count: The number of items to fetch
    ///   - completion: A PhotoResponse object or Error as a Result
    func fetchPhotos(for count: String, completion: @escaping PhotosResult) {
        flickrInteresting.per_page = count
        
        engine.fetchPhotos(method: flickrInteresting, completion: { (response, error) in
            
            guard let response = response,
                  error == nil else {
                completion(.failure(PhotoServiceError.networkError)); return
            }
            
            guard let decoded = self.getDecodedResponse(response: response) else {
                completion(.failure(PhotoServiceError.decodingError)); return
            }
            
            completion(.success(decoded))
        })
    }
    
    
    /// Decodes the PhotoResponse from the Flickr API
    /// - Parameter response: The raw network response
    /// - Returns: A decoded PhotoResponse object
    fileprivate func getDecodedResponse(response: [String:Any]) -> PhotoResponse? {
        var jsonData: Data = Data()
        
        do {
            let data = try JSONSerialization.data(withJSONObject: response, options: .prettyPrinted)
            jsonData = data
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(PhotoResponse.self, from: jsonData)
            return decoded
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
    /// Fetches photo urls using the FlickrKit framework
    /// - Parameter photos: An array of photo objects retrieved from the Flickr API
    /// - Returns: An array of URLs for loading images
    func fetchPhotoUrls(from photos: [Photo]) -> [URL] {
        return engine.fetchPhotoUrls(from: photos)
    }
    
    
}

protocol PhotoEngine {
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion)
    
    func fetchPhotoUrls(from photos: [Photo]) -> [URL]
}

extension FlickrKit: PhotoEngine {
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion) {
        call(method, completion: completion)
    }
    
    func fetchPhotoUrls(from photos: [Photo]) -> [URL] {
        var photoUrls: [URL] = []
        
        photos.forEach({
            let photoURL = FlickrKit.shared().photoURL(for: .medium640, photoID: $0.id, server: $0.server, secret: $0.secret, farm: "\($0.farm)")
            photoUrls.append(photoURL)
        })
        
        return photoUrls
    }
}

typealias PhotosResult = (Result<PhotoResponse, Error>) -> Void

/// Custom error cases for the FlickrService
enum PhotoServiceError: Error {
    case decodingError
    case networkError
}

typealias Handler = ([URL], Error) -> Void
