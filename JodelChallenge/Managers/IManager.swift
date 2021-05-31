//
//  IManager.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 30.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

protocol IManager: AnyObject {
    
    func getPhotos(page: Int,
                   completion: @escaping (_ photos: Photos?,
                                          _ error: Error?) -> Void)
}
