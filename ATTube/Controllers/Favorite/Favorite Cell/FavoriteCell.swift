//
//  FavoriteCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

private extension CGFloat {
    static let collectionCellWidth: CGFloat = 180
    static let paddingTop: CGFloat = 0
    static let paddingLeft: CGFloat = 5 * Ratio.widthIPhone6
    static let paddingRight: CGFloat = 5 * Ratio.widthIPhone6
    static let paddingBottom: CGFloat = 0
    static let minimumLineSpacing: CGFloat = 5 * Ratio.widthIPhone6
}

class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var playlistNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        autoFontSize()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCellAtIndex(index: Int) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(FavoriteCollectionCell)
        contentView.backgroundColor = index % 2 == 0 ? Color.bgFirstCell : Color.bgSecondCell
    }

    static func getCellHeight() -> CGFloat {
        return 185 * Ratio.widthIPhone6
    }

    func autoFontSize() {
        let helveticaFont = HelveticaFont()
        playlistNameLabel.font = helveticaFont.Regular(18)
    }
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension FavoriteCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(FavoriteCollectionCell.self, forIndexPath: indexPath)
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension FavoriteCell: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: Ratio.heightIPhone6 * CGFloat.collectionCellWidth, height: collectionView.bounds.size.height)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: CGFloat.paddingTop,
                left: CGFloat.paddingLeft,
                bottom: CGFloat.paddingBottom,
                right: CGFloat.paddingRight)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return CGFloat.minimumLineSpacing
    }
}
