//
//  SearchVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import MapKit
import SVPullToRefresh

class SearchVC: ViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var searchResultTableView: UITableView!
    @IBOutlet private weak var messageLabel: UILabel!

    private var searchKey = ""
    private var nextPageToken: String?
    private var isLoadMore = true
    private var limit = 10
    private var searchVideos: [Video] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = Color.white
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self

        searchResultTableView.registerNib(PlayerCell)
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self

        // setup pull-to-refresh
        searchResultTableView.addPullToRefreshWithActionHandler {
            self.loadVideo(isRefresh: true)
        }

        // setup infinite scrolling
        searchResultTableView.addInfiniteScrollingWithActionHandler {
            self.loadVideo(isRefresh: false)
        }
        configPullToRefreshView()

    }

    override func loadData() { }

    // MARK:- Private function
    private func autoFontSize() {
        let helvetical = HelveticaFont()
        messageLabel.font = helvetical.Regular(19)
    }

    private func configPullToRefreshView() {
        searchResultTableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        searchResultTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
    }

    private func loadVideo(isRefresh refresh: Bool) {
        if searchKey != "" {
            messageLabel.hidden = true
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            if refresh {
                nextPageToken = nil
                self.searchVideos.removeAll()
                self.searchResultTableView.reloadData()
            }
            
            APIManager.sharedInstance.getVideosWith(searchKey, maxResults: limit, nextPageToken: nextPageToken) { (videos, nextPageToken, error) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.searchResultTableView.pullToRefreshView.stopAnimating()
                self.searchResultTableView.infiniteScrollingView.stopAnimating()
                
                if let videos = videos where error == nil {
                    self.nextPageToken = nextPageToken
                    print(self.nextPageToken)
                    self.searchVideos.appendContentsOf(videos)
                    self.searchResultTableView.reloadData()
                    
                }
            }
        } else {
            self.searchResultTableView.pullToRefreshView.stopAnimating()
            self.searchResultTableView.infiniteScrollingView.stopAnimating()
        }
    }

    private func deleteData() {
        APIManager.sharedInstance.cancel()
        searchVideos.removeAll()
        searchResultTableView.reloadData()
        messageLabel.hidden = false
    }

    // MARK: - IBAciton
    @IBAction private func dismissViewController(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

}

// MARK:- UITableViewDataSource, UITableViewDelegate
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchVideos.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlayerCell.getCellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PlayerCell)
        let video = searchVideos[indexPath.row]
        cell.configCellAtIndex(indexPath.row, object: video)
        return cell
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchKey = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        deleteData()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        searchKey = searchText
        if searchText == "" {
            deleteData()
        } else {
            loadVideo(isRefresh: true)
        }
    }
}
