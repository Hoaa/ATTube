//
//  FavoriteVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils

class FavoriteVC: ViewController {

    // MARK:- Outlet
    @IBOutlet private weak var tableView: UITableView!

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

    override func loadData() { }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let favoriteCell = tableView.dequeue(FavoriteCell)
        favoriteCell.configCellAtIndex(indexPath.row)
        return favoriteCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return FavoriteCell.getCellHeight()
    }
}
