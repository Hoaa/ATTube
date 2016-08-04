//
//  TableViewCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

private extension CGFloat {
	static let cellHeight: CGFloat = 255
}

class HomeCell: UITableViewCell {

	// MARK - Outlet
	@IBOutlet private weak var photo: UIImageView!
	@IBOutlet private weak var name: UILabel!
	@IBOutlet private weak var time: UILabel!
	@IBOutlet private weak var infomation: UILabel!
	@IBOutlet private weak var totalViews: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}

	func configCellAtIndex(index: Int) {
		contentView.backgroundColor = index % 2 == 0 ? Color.bgFirstCell : Color.bgSecondCell
	}

	static func getCellHeight() -> CGFloat {
		return CGFloat.cellHeight * Ratio.widthIPhone6
	}
}
