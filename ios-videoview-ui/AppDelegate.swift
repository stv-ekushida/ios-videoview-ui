//
//  AppDelegate.swift
//  ios-videoview-ui
//
//  Created by Kushida　Eiji on 2016/12/04.
//  Copyright © 2016年 Kushida　Eiji. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var restorePlayer: AVPlayer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Remove the player.
        let vc = window?.rootViewController as? ViewController
        restorePlayer = vc?.playerView.player
        vc?.playerView.player = nil
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Restore the player.
        let vc = window?.rootViewController as? ViewController
        vc?.playerView.player = restorePlayer
    }
}

