//
//  HomeVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configUI()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

	}

	// MARK - Init UI & Data
	func configUI() {
		self.title = Strings.HomeTitle
	}

}
