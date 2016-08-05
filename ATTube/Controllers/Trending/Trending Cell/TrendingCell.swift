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
    @IBOutlet private weak var namelabel: UILabel!
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
        contentView.backgroundColor = index % 2 == 0 ? Color.bgFirstCell : Color.bgSecondCell
    }

    static func getCellHeight() -> CGFloat {
        return 255 * Ratio.widthIPhone6
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        namelabel.font = helveticaFont.Regular(18)
        durationLabel.font = helveticaFont.Light(14)
        descriptionLabel.font = helveticaFont.Regular(13)
        totalViewsLabel.font = helveticaFont.Regular(13)
    }
}
