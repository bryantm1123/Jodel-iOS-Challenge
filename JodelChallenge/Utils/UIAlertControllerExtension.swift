//
//  UIAlertControllerExtension.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 5/30/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    func show() {
        UIApplication.shared.keyWindow?.rootViewController?.present(self,
                                                                    animated: true,
                                                                    completion: nil)
    }
}
