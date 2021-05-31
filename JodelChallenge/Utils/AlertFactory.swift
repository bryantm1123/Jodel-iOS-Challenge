//
//  AlertFactory.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 5/30/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

class AlertFactory {
    
    static func `default`(title: String = "error", message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        return alert
    }
}
