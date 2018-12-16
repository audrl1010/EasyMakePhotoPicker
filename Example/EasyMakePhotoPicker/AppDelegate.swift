//
//  AppDelegate.swift
//  EasyMakePhotoPicker
//
//  Created by audrl1010 on 06/29/2017.
//  Copyright (c) 2017 audrl1010. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = MainVC()
    window?.makeKeyAndVisible()
    return true
  }
}


