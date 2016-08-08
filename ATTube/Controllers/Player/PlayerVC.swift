//
//  PlayerVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SVPullToRefresh

class PlayerVC: ViewController {

    @IBOutlet private weak var videosTableView: UITableView!

    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var totalViewsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        autoFontSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        videosTableView.registerNib(PlayerCell)
        videosTableView.dataSource = self
        videosTableView.delegate = self

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

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        videoNameLabel.font = helveticaFont.Regular(20)
        totalViewsLabel.font = helveticaFont.Light(14)
        descriptionLabel.font = helveticaFont.Regular(14)
    }

    @IBAction func dismissViewController(sender: UIButton) {
        dismissViewControllerAnimated(true) { }
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension PlayerVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let playerCell = tableView.dequeue(PlayerCell)
        playerCell.configCellAtIndex(indexPath.row)
        return playerCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlayerCell.getCellHeight()
    }
}
