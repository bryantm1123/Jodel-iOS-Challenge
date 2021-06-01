//
//  FlickrServiceTests.swift
//  JodelChallengeTests
//
//  Created by Matt Bryant on 5/22/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class FlickrServiceTests: XCTestCase {
    
    var sut: FlickrService?
    var mockEngine: MockPhotoEngine?
    let bundle = Bundle(for: FlickrServiceTests.self)
    let resource = "PhotosSampleResponse"

    override func setUpWithError() throws {
        mockEngine = MockPhotoEngine()
        sut = FlickrService(mockEngine!)
    }

    override func tearDownWithError() throws {
        mockEngine = nil
        sut = nil
    }

    
    /// Test that our decoder properly decodes our response object given a mock response object
    /// - Throws: An error if one is caught
    func testDecodingWithValidResponse() throws {
        // Given
        mockEngine?.response = getDataDictionaryResponse(from: bundle, for: resource, of: "json")
        let expectedFirstPhotoId = "51190594964"
        let expectedFirstPhotoTitle = "*Seceda at the golden hour*"
        
        // When
        sut?.fetchPhotos(for: 10, on: 1, completion: { result in
            
            // Then
            switch result {
                case .success(let response):
                    let first = response.photos.photo.first
                    XCTAssertEqual(first?.id, expectedFirstPhotoId)
                    XCTAssertEqual(first?.title, expectedFirstPhotoTitle)
            case .failure(let error):
                XCTFail("\(error)")
            }
        })
    }
    
    
    /// Test that we receive our expected error enum case when decoding our response object fails
    /// - Throws: An error if one is caught
    func testErrorResponseOnInvalidDecoding() throws {
        // Given
        mockEngine?.response = [:]
        let expectedError = PhotoServiceError.decodingError
        
        // When
        sut?.fetchPhotos(for: 10, on: 1, completion: { result in
            
            // Then
            switch result {
                case .success(let response):
                    XCTFail("\(response)")
            case .failure(let error):
                XCTAssertEqual(error as! PhotoServiceError, expectedError)
            }
        })
    }
    
    
    /// Test that we receive our expected error enum case when our network response fails
    /// - Throws: An error if one is caught
    func testExpectedErrorOnErrorResponse() throws {
        // Given
        mockEngine?.response = [:]
        mockEngine?.error = getError()
        let expectedError = PhotoServiceError.networkError
        
        // When
        sut?.fetchPhotos(for: 10, on: 1, completion: { result in
            
            // Then
            switch result {
                case .success(let response):
                    XCTFail("\(response)")
            case .failure(let error):
                XCTAssertEqual(error as! PhotoServiceError, expectedError)
            }
        })
    }
    
    
    /// Tests that the service will return a valid URL if passed data from the photo
    /// - Throws: An error if one is caught
    func testURLReturnedFromPhotoResponse() throws {
        // Given
        let photos: [Photo] = [Photo(id: "1", owner: "me", secret: "secret", server: "server", farm: 0, title: "mockPhoto", isPublic: 0, isFriend: 0, isFamily: 0)]
        
        // When
        let models: [FeedModel] = (sut?.fetchFeedModels(from: photos))!
        
        // Then
        XCTAssertTrue(models.first!.url.absoluteString.contains(photos.first!.server))
    }
}


/// A mock PhotoEngine object that we can pass to our service to test given response and error cases
class MockPhotoEngine: PhotoEngine {
    
    var response: [String:Any]?
    var error: Error?
    
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion) {
        completion(response, error)
    }
    
    func buildFeedModels(from photos: [Photo]) -> [FeedModel] {
        let id = photos.first?.id
        let server = photos.first?.server
        let secret = photos.first?.secret
        let url = URL(string: "https://farm\(id ?? "").static.flickr.com/\(server ?? "")/\(secret ?? "")).jpg")!
        let title = "myTitle"
        
        return [
            FeedModel(title: title, url: url)
        ]
    }
    
}
