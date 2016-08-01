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
		// Dispose of any resources that can be recreated.
	}

	func configTabbarController() {
		let homeVC = HomeVC(nibName: "HomeVC", bundle: nil)
		let favoriteVC = SearchVC(nibName: "SearchVC", bundle: nil)
		let mapVC = PlaylistsVC(nibName: "PlaylistsVC", bundle: nil)

		let homeNavi = UINavigationController(rootViewController: homeVC)
		let favoriteNavi = UINavigationController(rootViewController: favoriteVC)
		let mapNavi = UINavigationController(rootViewController: mapVC)

		let homeItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_home"), selectedImage: UIImage(named: ""))
		let favoriteItem = UITabBarItem(title: "Search", image: UIImage(named: "ic_home"), selectedImage: UIImage(named: ""))
		let mapItem = UITabBarItem(title: "Playlists", image: UIImage(named: "ic_home"), selectedImage: UIImage(named: ""))

		homeVC.tabBarItem = homeItem
		favoriteVC.tabBarItem = favoriteItem
		mapVC.tabBarItem = mapItem

		// Create Tabbar
		viewControllers = [homeNavi, favoriteNavi, mapNavi]
		tabBar.tintColor = MyColor.tabBarTintColor
	}

}
