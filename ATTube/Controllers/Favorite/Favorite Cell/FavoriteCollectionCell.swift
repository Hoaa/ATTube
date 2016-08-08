//
//  FavoriteCollectCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/4/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

class FavoriteCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var descriptionlabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        autoFontSize()
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        videoNameLabel.font = helveticaFont.Regular(16)
        durationLabel.font = helveticaFont.Light(14)
        descriptionlabel.font = helveticaFont.Regular(12)
    }
}
