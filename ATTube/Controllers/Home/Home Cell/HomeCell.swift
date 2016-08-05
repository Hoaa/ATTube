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
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var totalViewsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        autoFontSize()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCellAtIndex(index: Int) {
        contentView.backgroundColor = index % 2 == 0 ? Color.black10 : Color.black20
    }

    static func getCellHeight() -> CGFloat {
        return CGFloat.cellHeight * Ratio.widthIPhone6
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        nameLabel.font = helveticaFont.Regular(18)
        durationLabel.font = helveticaFont.Light(14)
        descriptionLabel.font = helveticaFont.Regular(13)
        totalViewsLabel.font = helveticaFont.Regular(13)
    }
}
