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
            self.loadVideos(isRefresh: true)
        }

        // setup infinite scrolling
        videosTableView.addInfiniteScrollingWithActionHandler {
            self.loadVideos(isRefresh: false)
        }

        configPullToRefreshView()
    }

    override func loadData() {
        self.loadVideos(isRefresh: true)
    }

    // MARK: - Private function
    private func configPullToRefreshView() {
        videosTableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        videosTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
    }

    private func loadVideos(isRefresh refresh: Bool) {
        if !Reachability.isConnectedToNetwork() {
            Message.warning(Strings.warning, subTitle: Strings.networkFailedMessage)
            return
        }
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if refresh {
            nextPageToken = nil
            trendingVideos.removeAll()
            videosTableView.reloadData()
        }
        APIManager.sharedInstance.getTrendingVideos(limit, regionCode: regionCode, nextPageToken: nextPageToken) {
            (videos, nextPageToken, error) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            self.videosTableView.pullToRefreshView.stopAnimating()
            self.videosTableView.infiniteScrollingView.stopAnimating()
            if let videos = videos where error == nil {
                self.nextPageToken = nextPageToken
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
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension TrendingVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingVideos.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let video = trendingVideos[indexPath.row]
        let trendingCell = tableView.dequeue(TrendingCell)
        trendingCell.configCellAtIndex(indexPath.row, object: video)
        trendingCell.delegate = self
        return trendingCell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TrendingCell.getCellHeight()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}

extension TrendingVC: AddPlaylistDelegate {

    func addVideoToPlaylistAt(indexCell: Int) {
        showAlertAddVideoToPlaylist(trendingVideos[indexCell])
    }
}
