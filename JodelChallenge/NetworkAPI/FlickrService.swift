//
//  FlickrService.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/21/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation


class FlickrService {
    
    private let engine: PhotoEngine
    var flickrInteresting = FKFlickrInterestingnessGetList()
    
    init(_ engine: PhotoEngine = FlickrKit.shared()) {
        self.engine = engine
    }
    
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
    
    
}

enum PhotoServiceError: Error {
    case decodingError
    case networkError
}

typealias PhotosResult = (Result<PhotoResponse, Error>) -> Void

extension FlickrKit: PhotoEngine {
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion) {
        call(method, completion: completion)
    }
}

protocol PhotoEngine {
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion)
}

typealias Handler = ([URL], Error) -> Void
