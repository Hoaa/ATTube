//
//  FavoriteVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift

private extension Selector {
    static let reloadData = #selector(FavoriteVC.reloadData)
}

class FavoriteVC: ViewController {

    // MARK:- Outlet
    @IBOutlet private weak var tableView: UITableView!

    // MARK:- Property
    private var playlists: Results<Playlist>?
    var delegate: PlayerVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        tableView.registerNib(FavoriteCell)
    }
    override func loadData() {
        playlists = RealmManager.getAvailablePlaylists()
        addNotification()
    }

    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: .reloadData,
            name: Strings.notificationAddPlaylist,
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: .reloadData,
            name: Strings.notificationUpdatePlaylist,
            object: nil)

    }

    @objc private func reloadData() {
        tableView.reloadData()
    }

//    @objc private func reloadCellAfterDeleteVideo(index: Int) {
//        tableView.beginUpdates()
//        let indexPath = NSIndexPath(forRow: index, inSection: 0)
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        tableView.endUpdates()
//    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists?.count ?? 0
    }

    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let playlist = playlists?[indexPath.row]
            let favoriteCell = tableView.dequeue(FavoriteCell)
            favoriteCell.delegate = self
            favoriteCell.configCellAtIndex(indexPath.row, object: playlist)
            return favoriteCell
    }

    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return FavoriteCell.getCellHeight()
    }
}

extension FavoriteVC: FavoriteCellDelegate {
    func playVideo(indexVideo: Int?, InPlaylist indexPlaylist: Int) {
        delegate?.playVideo(indexVideo,
            InPlaylist: playlists?[indexPlaylist],
            isShowPlaylist: true)
        // let  player = PlayerVC(videos: playlists?[index].videos)
        // self.presentViewController(player, animated: true, completion: nil)
    }
}
