//
//  AppDelegate.swift
//  Fitness-kit
//
//  Created by Yuri Ivashin on 25.02.2020.
//  Copyright © 2020 The Homber Team. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = MainTableViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

