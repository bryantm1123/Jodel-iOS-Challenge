//
//  FullImageView.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 30.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

protocol FullImageView: AnyObject {
    func setImage(url: URL)
    func setTitle(title: String)
}
