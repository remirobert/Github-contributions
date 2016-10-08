//
//  AppDelegate.swift
//  Github-contribution
//
//  Created by Remi Robert on 05/10/2016.
//  Copyright © 2016 Remi Robert. All rights reserved.
//

import UIKit
import WatchConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        WatchSessionManager.default.startSession()
        return true
    }
}
