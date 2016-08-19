//
//  FavoriteCell.swift
//  ATTube
//
//  Created by Asiantech1 on 8/3/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

private extension CGFloat {
    static let collectionCellWidth: CGFloat = 180 * Ratio.widthIPhone6
    static let minimumLineSpacing: CGFloat = 5 * Ratio.widthIPhone6

    static let paddingTop: CGFloat = 0
    static let paddingLeft: CGFloat = 5 * Ratio.widthIPhone6
    static let paddingRight: CGFloat = 5 * Ratio.widthIPhone6
    static let paddingBottom: CGFloat = 0

    static let cellHeight: CGFloat = 185 * Ratio.widthIPhone6
    static let titleHeight: CGFloat = 35 * Ratio.widthIPhone6
}

class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var playlistNameLabel: UILabel!

    @IBOutlet weak var totalVideoLabel: UILabel!

    private var playlist: Playlist? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        autoFontSize()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCellAtIndex(index: Int, object: Playlist?) {
        playlistNameLabel.text = object?.title
        totalVideoLabel.text = "\(object?.videos.count ?? 0)"
        playlist = object
        collectionView.reloadData()

        collectionView.registerNib(FavoriteCollectionCell)
        collectionView.delegate = self
        collectionView.dataSource = self
        contentView.backgroundColor = index % 2 == 0 ? Color.black10 : Color.black20
    }

    static func getCellHeight() -> CGFloat {
        return .cellHeight
    }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        playlistNameLabel.font = helveticaFont.Regular(18)
        totalVideoLabel.font = helveticaFont.Regular(17)
    }

}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension FavoriteCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlist?.videos.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let video = playlist?.videos[indexPath.row]
        let favoriteCollectionCell = collectionView.dequeue(FavoriteCollectionCell.self, forIndexPath: indexPath)
        favoriteCollectionCell.configCellAtIndex(indexPath.row, object: video)
        return favoriteCollectionCell
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension FavoriteCell: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: .collectionCellWidth, height: collectionView.bounds.size.height)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: .paddingTop,
                left: .paddingLeft,
                bottom: .paddingBottom,
                right: .paddingRight)
    }

    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return .minimumLineSpacing
    }
}
