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
    var mockEngine: PhotoEngine?
    var didReceivePhotosCalled: Bool = false
    var didReceiveErrorCalled: Bool = false

    override func setUpWithError() throws {
        sut = PhotosPresenter(with: self)
        mockEngine = MockPhotoEngine()
        service = FlickrService(mockEngine!)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testExample() throws {
        
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
