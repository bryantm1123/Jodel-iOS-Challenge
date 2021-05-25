//
//  PhotosPresenterTests.swift
//  JodelChallengeTests
//
//  Created by Matt Bryant on 5/24/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class PhotosPresenterTests: XCTestCase {
    
    var sut: PhotosPresenter?
    var service: FlickrService?
    var mockEngine: MockPhotoEngine?
    let bundle = Bundle(for: FlickrServiceTests.self)
    let resource = "PhotosSampleResponse"
    var didReceivePhotosCalled: Bool = false
    var didReceiveErrorCalled: Bool = false
    var expectation: XCTestExpectation?
    

    override func setUpWithError() throws {
        sut = PhotosPresenter(with: self)
        mockEngine = MockPhotoEngine()
        service = FlickrService(mockEngine!)
        expectation = XCTestExpectation(description: "Wait for url fetch completion.")
    }

    override func tearDownWithError() throws {
        sut = nil
        mockEngine = nil
        service = nil
        expectation = nil
    }

    
    /// Tests that the presenter calls the didReceivePhotos delegate method upon a successful response
    /// - Throws: An error if one is caught
    func testDidRecievePhotosCalledWithValidResponse() throws {
        // Given
        mockEngine?.response = getDataDictionaryResponse(from: bundle, for: resource, of: "json")
        mockEngine?.error = nil
        let timeInSeconds = 2.0 // time you need for all tasks to be finished
        
        // When
        sut?.fetchPhotos(for: "15", on: "1")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds, execute: {
            self.expectation?.fulfill()
        })
        
        wait(for: [expectation!], timeout: timeInSeconds + 1.0)
        
        // Then
        XCTAssertTrue(self.didReceivePhotosCalled)
        
    }
    
    /// Tests that the presenter calls the didReceiveError delegate method upon an error response
    /// - Throws: An error if one is caught
    func testDidRecieveErrorCalledWithErrorResponse() throws {
        // Given
        let mockEngine = MockPhotoEngine()
        mockEngine.response = nil
        mockEngine.error = getError()
        let timeInSeconds = 2.0 // time you need for all tasks to be finished
        sut?.photoService = FlickrService(mockEngine)
        
        // When
        sut?.fetchPhotos(for: "15", on: "1")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + timeInSeconds, execute: {
            self.expectation?.fulfill()
        })
        
        wait(for: [expectation!], timeout: timeInSeconds + 1.0)
        
        // Then
        XCTAssertTrue(self.didReceiveErrorCalled)
        
    }
}

extension PhotosPresenterTests: PhotoDeliveryDelegate {
    func didReceivePhotos() {
        didReceivePhotosCalled = true
    }
    
    func didReceiveError(_ error: Error) {
        didReceiveErrorCalled = true
    }
}
