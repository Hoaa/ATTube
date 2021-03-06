//
//  PlayerCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

private extension CGFloat {
    static let cellHeight: CGFloat = 110 * Ratio.widthIPhone6
}

class PlayerCell: UITableViewCell {

    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var totalViewsLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        autoFontSize()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCellAtIndex(index: Int, object: Video?) {
        contentView.backgroundColor = index % 2 == 0 ? Color.black10 : Color.black20
        videoNameLabel.text = object?.title ?? "Miley"
        descriptionLabel.text = object?.description ?? "Description description  description  description  description "
        totalViewsLabel.text = HandleData.viewCount(object?.viewCount) ?? "1M Views"
        durationLabel.text = HandleData.duration(object?.duration) ?? "2:30"
        
        if let thumbnailURLString = object?.highThumbnailURL, thumbnailURL = NSURL(string: thumbnailURLString) {
            photoImageView.sd_setImageWithURL(thumbnailURL, placeholderImage: UIImage(assetIdentifier: .BgHomeCell))
        }
    }

    static func getCellHeight() -> CGFloat {
        return .cellHeight
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        videoNameLabel.font = helveticaFont.Regular(20)
        descriptionLabel.font = helveticaFont.Regular(14)
        totalViewsLabel.font = helveticaFont.Regular(14)
        durationLabel.font = helveticaFont.Bold(14)
    }
}
