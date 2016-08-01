//
//  AppDelegate.swift
//  ATTube
//
//  Created by AsianTech on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

//	static let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window?.rootViewController = BaseTabBarController()
		window?.backgroundColor = UIColor.whiteColor()
		window?.makeKeyAndVisible()
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
	}

	func applicationDidEnterBackground(application: UIApplication) {
	}

	func applicationWillEnterForeground(application: UIApplication) {
	}

	func applicationDidBecomeActive(application: UIApplication) {
	}

	func applicationWillTerminate(application: UIApplication) {
	}
}
