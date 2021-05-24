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

    
    /// Test that our decoder properly decodes our response object given a mock response object
    /// - Throws: An error if one is caught
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
    
    
    /// Test that we receive our expected error enum case when decoding our response object fails
    /// - Throws: An error if one is caught
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
    
    
    /// Test that we receive our expected error enum case when our network response fails
    /// - Throws: An error if one is caught
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


/// A mock PhotoEngine object that we can pass to our service to test given response and error cases
class MockPhotoEngine: PhotoEngine {
    
    var response: [String:Any]?
    var error: Error?
    
    func fetchPhotos(method: FKFlickrAPIMethod, completion: @escaping FKAPIRequestCompletion) {
        completion(response, error)
    }
}

// MARK: Stub functions
extension FlickrServiceTests {
    
    /// A stub function that returns our our sample photo response as data for passing to our service's decoder
    /// - Returns: An error if one is caught during conversion of the mock response to data
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
    
    
    /// A stub function that returns a custom error object used for testing
    /// - Returns: A custom error that can be passed to our mock
    func getError() -> Error {
        return NSError(domain: "myError", code: 0, userInfo: nil)
    }
}
