//
//  BaseTabBarController.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configTabbarController()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	func configTabbarController() {
		let homeVC = HomeVC(nibName: Strings.HomeNibName, bundle: nil)
		let trendingVC = TrendingVC(nibName: Strings.TrendingNibName, bundle: nil)
		let favoriteVC = FavoriteVC(nibName: Strings.FavoriteNibName, bundle: nil)

		let homeNavi = UINavigationController(rootViewController: homeVC)
		let trendingNavi = UINavigationController(rootViewController: trendingVC)
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)

		let homeItem = UITabBarItem(title: Strings.HomeTitle, image: UIImage(named: Strings.HomeTabBarIcon), selectedImage: UIImage(named: ""))
		let trendingItem = UITabBarItem(title: Strings.TrendingTitle, image: UIImage(named: Strings.HomeTabBarIcon), selectedImage: UIImage(named: ""))
		let favoriteItem = UITabBarItem(title: Strings.FavoriteTitle, image: UIImage(named: Strings.HomeTabBarIcon), selectedImage: UIImage(named: ""))

		homeVC.tabBarItem = homeItem
		trendingVC.tabBarItem = trendingItem
		favoriteVC.tabBarItem = favoriteItem

		// Create Tabbar
		viewControllers = [homeNavi, trendingNavi, favoriteNavi]
		tabBar.tintColor = Color.tabBarTint
	}

}
