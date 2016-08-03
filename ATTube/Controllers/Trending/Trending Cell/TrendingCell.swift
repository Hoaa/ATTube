//
//  TableViewCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class TrendingCell: UITableViewCell {

	// MARK - outlet
	@IBOutlet private weak var photo: UIImageView!
	@IBOutlet private weak var name: UILabel!
	@IBOutlet private weak var time: UILabel!
	@IBOutlet private weak var infomation: UILabel!
	@IBOutlet private weak var totalViews: UILabel!

	// MARK - property
	var index = 0

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	func setBackgroundColorForContentView() {
		contentView.backgroundColor = index % 2 == 0 ? Color.bgFirstCell : Color.bgSecondCell
	}
}