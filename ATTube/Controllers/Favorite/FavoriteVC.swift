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
    }

    @objc private func reloadData() {
        tableView.reloadData()
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
            favoriteCell.configCellAtIndex(indexPath.row, object: playlist)
            return favoriteCell
    }

    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return FavoriteCell.getCellHeight()
    }
}
