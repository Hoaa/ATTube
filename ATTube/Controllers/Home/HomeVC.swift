//
//  HomeVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class HomeVC: ViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		configUI()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

	}

	// MARK - Init UI & Data
	override func configUI() {
		title = Strings.HomeTitle
	}

	override func loadData() {
	}
}
