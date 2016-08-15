//
//  HomeVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import SVPullToRefresh

class HomeVC: ViewController {

    // MARK - Outlet
    @IBOutlet private weak var videosTableView: UITableView!

    // MARK:- Property
    var delgate: PlayerVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        videosTableView.registerNib(HomeCell)

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
        videosTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
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

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension HomeVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let homeCell = tableView.dequeue(HomeCell)
        homeCell.configCellAtIndex(indexPath.row)
        return homeCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HomeCell.getCellHeight()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delgate?.presentViewController()
    }
}
