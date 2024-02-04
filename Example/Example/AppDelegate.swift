//
//  AppDelegate.swift
//  Example
//
//  Created by Duc IT. Nguyen Minh on 04/02/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let tabbarCtl = UITabBarController()
        window.rootViewController = tabbarCtl
        window.makeKeyAndVisible()
        return true
    }
}

