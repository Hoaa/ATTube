//
//  TableViewCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SDWebImage

private extension String {
    static let Hour = "H"
    static let Minute = "M"
    static let Second = "S"
}

class TrendingCell: UITableViewCell {

    // MARK - outlet
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

    func configCellAtIndex(index: Int, With object: Video) {
        contentView.backgroundColor = index % 2 == 0 ? Color.black10 : Color.black20
        selectionStyle = UITableViewCellSelectionStyle.None

        if let thumbnailURLString = object.highThumbnailURL, thumbnailURL = NSURL(string: thumbnailURLString) {
            photoImageView.sd_setImageWithURL(thumbnailURL, placeholderImage: UIImage(assetIdentifier: .BgHomeCell))
        }
        nameLabel.text = object.title
        durationLabel.text = shortTime(object.duration)
        descriptionLabel.text = object.description
        totalViewsLabel.text = viewCount(object.viewCount)
    }

    static func getCellHeight() -> CGFloat {
        return 255 * Ratio.widthIPhone6
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        nameLabel.font = helveticaFont.Regular(18)
        durationLabel.font = helveticaFont.Light(14)
        descriptionLabel.font = helveticaFont.Regular(13)
        totalViewsLabel.font = helveticaFont.Regular(13)
    }

    private func shortTime(time: String?) -> String {
        var result = ""
        if let time = time {
            var timeString = (time as NSString).substringFromIndex(2)
            var items: [String] = []

            if timeString.rangeOfString(.Hour) != nil {
                items = timeString.componentsSeparatedByString(.Hour)
                result += items.first!
                timeString = items.last!
            }

            if timeString.rangeOfString(.Minute) == nil {
                result += result.length == 0 ? "0" : ":00"
            } else {
                items = timeString.componentsSeparatedByString(.Minute)
                result += result.length == 0 ? items.first! : (":" + (items.first!.length == 1 ? ("0" + items.first!) : items.first!))
                timeString = items.last!
            }

            if timeString.rangeOfString(.Second) == nil {
                result += ":00"
            } else {
                items = timeString.componentsSeparatedByString(.Second)
                result += items.first!.length == 1 ? ":0\(items.first!)" : ":\(items.first!)"
            }
        }
        return result
    }

    private func viewCount(viewCountString: String?) -> String {
        if let viewCountString = viewCountString {
            guard let viewCount = Int(viewCountString) else {
                return ""
            }
            if viewCount > 999999 {
                return (viewCountString as NSString).substringToIndex(viewCountString.length - 6) + "M Views"
            } else if viewCount > 999 {
                return (viewCountString as NSString).substringToIndex(viewCountString.length - 3) + "T Views"
            } else {
                return viewCountString
            }
        }
        return ""
    }
}
