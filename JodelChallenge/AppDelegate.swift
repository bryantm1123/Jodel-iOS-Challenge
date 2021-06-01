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
        
        guard let flikrAPIKey = Bundle.main.object(forInfoDictionaryKey: "FlickrAPIKey") as? String,
              let flicrAPISecret = Bundle.main.object(forInfoDictionaryKey: "FlickrAPISecret") as? String else {
            debugPrint("Unable to initialize FlickrKit API key and secret.")
            return true
        }
        
        FlickrKit.shared().initialize(withAPIKey: flikrAPIKey, sharedSecret: flicrAPISecret)

        return true
    }
}

