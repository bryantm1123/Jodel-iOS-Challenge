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

    override func setUpWithError() throws {
        mockEngine = MockPhotoEngine()
        sut = FlickrService(mockEngine!)
    }

    override func tearDownWithError() throws {
        mockEngine = nil
        sut = nil
    }

    func testDecodingWithValidResponse() throws {
        // Given
        mockEngine?.response = getPhotoResponse()
        let expectedFirstPhotoId = "51190594964"
        let expectedFirstPhotoTitle = "*Seceda at the golden hour*"
        
        // When
        sut?.fetchPhotos(for: "10", completion: { result in
            
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
    
    func testErrorResponseOnInvalidDecoding() throws {
        // Given
        mockEngine?.response = [:]
        let expectedError = PhotoServiceError.decodingError
        
        // When
        sut?.fetchPhotos(for: "10", completion: { result in
            
            // Then
            switch result {
                case .success(let response):
                    XCTFail("\(response)")
            case .failure(let error):
                XCTAssertEqual(error as! PhotoServiceError, expectedError)
            }
        })
    }
    
    func testExpectedErrorOnErrorResponse() throws {
        // Given
        mockEngine?.response = [:]
        mockEngine?.error = getError()
        let expectedError = PhotoServiceError.networkError
        
        // When
        sut?.fetchPhotos(for: "10", completion: { result in
            
            // Then
            switch result {
                case .success(let response):
                    XCTFail("\(response)")
            case .failure(let error):
                XCTAssertEqual(error as! PhotoServiceError, expectedError)
            }
        })
    }

}

class MockPhotoEngine: PhotoEngine {
    
    var response: [String:Any]?
    var error: Error?
    
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion) {
        completion(response, error)
    }
}

extension FlickrServiceTests {
    func getPhotoResponse() -> [String:Any]? {
        let bundle = Bundle(for: FlickrServiceTests.self)
        if let path = bundle.path(forResource: "PhotosSampleResponse", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    return dictionary
                }
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
    func getError() -> Error {
        return NSError(domain: "myError", code: 0, userInfo: nil)
    }
}
