//
//  AutoplayCell.swift
//  ATTube
//
//  Created by Quang Phù on 9/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let cellHeight: CGFloat = 50 * Ratio.widthIPhone6
}

typealias AutoPlay = (Bool) -> Void

class AutoplayCell: UITableViewCell {

    @IBOutlet weak var upNextLabel: UILabel!
    @IBOutlet weak var autoplayLabel: UILabel!

    var autoplay: AutoPlay?

    override func awakeFromNib() {
        super.awakeFromNib()
        autoFontSize()
        selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static func getCellHeight() -> CGFloat {
        return .cellHeight
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        upNextLabel.font = helveticaFont.Regular(15)
        autoplayLabel.font = helveticaFont.Bold(14)
    }

    @IBAction func didChangeValueAutoplay(sender: UISwitch) {
        autoplay?(sender.on)
    }
}
