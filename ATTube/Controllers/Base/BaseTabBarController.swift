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
		let homeVC = HomeVC.vc()
		let trendingVC = TrendingVC.vc()
		let favoriteVC = FavoriteVC.vc()

		let homeNavi = UINavigationController(rootViewController: homeVC)
		let trendingNavi = UINavigationController(rootViewController: trendingVC)
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)

		let homeItem = UITabBarItem(title: Strings.homeTitle, image: UIImage(assetIdentifier: .Home), selectedImage: UIImage(named: ""))
		let trendingItem = UITabBarItem(title: Strings.trendingTitle, image: UIImage(assetIdentifier: .Home), selectedImage: UIImage(named: ""))
		let favoriteItem = UITabBarItem(title: Strings.favoriteTitle, image: UIImage(assetIdentifier: .Favorite), selectedImage: UIImage(named: ""))

		homeVC.tabBarItem = homeItem
		trendingVC.tabBarItem = trendingItem
		favoriteVC.tabBarItem = favoriteItem

		// Create Tabbar
		viewControllers = [homeNavi, trendingNavi, favoriteNavi]
		tabBar.tintColor = Color.tabBarTint
	}

}
