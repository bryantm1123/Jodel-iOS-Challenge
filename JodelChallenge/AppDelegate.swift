//
//  AppDelegate.swift
//  JodelChallenge
//
//  Created by Michal Ciurus on 21/09/2017.
//  Copyright © 2017 Jodel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // TODO: Move the key and secret
        let apiKey = "92111faaf0ac50706da05a1df2e85d82"
        let secret = "89ded1035d7ceb3a"
        FlickrKit.shared().initialize(withAPIKey: apiKey, sharedSecret: secret)

        return true
    }
}

