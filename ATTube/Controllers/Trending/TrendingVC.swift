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

    // MARK: - Property
    var delegate: PlayerVCDelegate?
    private var trendingVideos: [Video] = []

    private var nextPageToken: String?
    private var isLoadMore = true
    private var limit = 10
    private var regionCode = "VN"

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
        handleRefresh()
    }

    // MARK: - Private function
    private func configPullToRefreshView() {
        videosTableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        videosTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
    }

    private func handleRefresh() {

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        APIManager.sharedInstance.getTrendingVideos(limit, regionCode: regionCode, nextPageToken: nil) {
            (videos, nextPageToken, error) in

            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.videosTableView.pullToRefreshView.stopAnimating()

            if let videos = videos where error == nil {
                self.nextPageToken = nextPageToken
                self.isLoadMore = nextPageToken == nil ? false : true
                self.trendingVideos.removeAll()
                self.trendingVideos.appendContentsOf(videos)
                self.videosTableView.reloadData()
            }
        }
    }

    private func handleLoadMore() {
        if isLoadMore {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            APIManager.sharedInstance.getTrendingVideos(limit, regionCode: regionCode, nextPageToken: nextPageToken) {
                (videos, nextPageToken, error) in

                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.videosTableView.infiniteScrollingView.stopAnimating()

                if let videos = videos where error == nil {
                    self.nextPageToken = nextPageToken
                    self.isLoadMore = nextPageToken == nil ? false : true
                    self.trendingVideos.appendContentsOf(videos)

                    self.videosTableView.beginUpdates()
                    var indexPaths = [NSIndexPath]()
                    for row in (self.trendingVideos.count - videos.count)..<self.trendingVideos.count {
                        indexPaths.append(NSIndexPath(forRow: row, inSection: 0))
                    }
                    self.videosTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                    self.videosTableView.endUpdates()

                }
            }
        } else {
            self.videosTableView.infiniteScrollingView.stopAnimating()
        }
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension TrendingVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingVideos.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let trendingCell = tableView.dequeue(TrendingCell)
        let video = trendingVideos[indexPath.row]
        trendingCell.configCellAtIndex(indexPath.row, With: video)
        return trendingCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrendingCell.getCellHeight()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.presentViewController()
    }
}
