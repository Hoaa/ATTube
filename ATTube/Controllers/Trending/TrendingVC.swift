//
//  TrendingVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SVPullToRefresh

class TrendingVC: ViewController {

    // MARK: - Outlet
    @IBOutlet private weak var videosTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        // Register xib for cell
        videosTableView.registerNib(TrendingCell)

        // setup pull-to-refresh
        videosTableView.addPullToRefreshWithActionHandler {
            self.handleRefresh()
        }

        // setup infinite scrolling
        videosTableView.addInfiniteScrollingWithActionHandler {
            self.handleLoadMore()
        }

        configPullToRefreshView()
    }

    override func loadData() {

    }

    // MARK: - Private function
    private func configPullToRefreshView() {
        videosTableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
    }

    private func handleRefresh() {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            print("refresh")
            self.videosTableView.pullToRefreshView.stopAnimating()
        }
    }

    private func handleLoadMore() {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            print("load more")
            self.videosTableView.infiniteScrollingView.stopAnimating()
        }
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension TrendingVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let trendingCell = tableView.dequeue(TrendingCell)
        trendingCell.configCellAtIndex(indexPath.row)
        return trendingCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrendingCell.getCellHeight()
    }
}
