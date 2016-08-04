//
//  FavoriteCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class FavoriteCell: UITableViewCell {

	var index = 0

	@IBOutlet weak var collectionView: UICollectionView!

	override func awakeFromNib() {
		super.awakeFromNib()

	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)

	}

	func setBackgroundColorForContentView() {
		contentView.backgroundColor = index % 2 == 0 ? Color.bgFirstCell : Color.bgSecondCell
	}

//	func initProtocal(viewController: UIViewController) {
//		collectionView.delegate = viewController
//		collectionView.dataSource = viewController
//	}

}
