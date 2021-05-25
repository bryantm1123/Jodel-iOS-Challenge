//
//  MockDataStubber.swift
//  JodelChallengeTests
//
//  Created by Matt Bryant on 5/24/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation
import XCTest

protocol MockDataStubber {
    func getDataDictionaryResponse(from bundle: Bundle, for resource: String, of fileType: String) -> [String:Any]?
    
    func getError() -> Error
}


// MARK: Stub functions
extension XCTest: MockDataStubber {
    
    /// A stub function that returns our  response as a dictionary for passing to our service's decoder
    /// - Returns: An error if one is caught during conversion of the mock response to data
    func getDataDictionaryResponse(from bundle: Bundle, for resource: String, of fileType: String) -> [String : Any]? {
        if let path = bundle.path(forResource: resource, ofType: fileType) {
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
    
    /// A stub function that returns our our sample photo response as data for passing to our service's decoder
    /// - Returns: An error if one is caught during conversion of the mock response to data
    
    
    /// A stub function that returns a custom error object used for testing
    /// - Returns: A custom error that can be passed to our mock
    func getError() -> Error {
        return NSError(domain: "myError", code: 0, userInfo: nil)
    }
}
