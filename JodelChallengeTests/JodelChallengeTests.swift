//
//  JodelChallengeTests.swift
//  JodelChallengeTests
//
//  Created by Michal Ciurus on 21/09/2017.
//  Copyright © 2017 Jodel. All rights reserved.
//

import XCTest
@testable import JodelChallenge

class JodelChallengeTests: XCTestCase {
    
    var presenter: FeedPresenter?
    var connection: IManager!
    
    override func setUp() {
        super.setUp()
        connection = Mock()
        presenter = FeedPresenter(view: UIViewController(), imageManager: connection)
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
        connection = nil
    }
    
    func testImagesAreLoaded() {
        presenter?.loadData()
        XCTAssert(presenter?.getPhotosList().isEmpty == false, "Images are not loaded")
    }
    
    func testNoInternetConnection() {
        let mockConnection: Mock? = connection as? Mock
        mockConnection?.networkState = .fail
        presenter?.loadData()
        XCTAssert(presenter?.getPhotosList().isEmpty == true, "Images are loaded")
    }
    
    func testDealyedSuccess() {
        let mockConnection: Mock? = connection as? Mock
        mockConnection?.networkState = .delayed
        presenter?.loadData()
        
        let exp = expectation(description: "Test after 5 seconds")
        _ = XCTWaiter.wait(for: [exp], timeout: 5.0)
                
        XCTAssert(presenter?.getPhotosList().isEmpty == false, "Images are not loaded")
    }
}
