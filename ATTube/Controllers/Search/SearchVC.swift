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

    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var searchResultTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        autoFontSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        searchResultTableView.dataSource = self
        searchResultTableView.delegate = self
        searchResultTableView.registerNib(PlayerCell)

        // setup pull-to-refresh
        searchResultTableView.addPullToRefreshWithActionHandler {
            self.loadVideo(true)
        }

        // setup infinite scrolling
        searchResultTableView.addInfiniteScrollingWithActionHandler {
            self.loadVideo(false)
        }
        configPullToRefreshView()
        searchTextField.becomeFirstResponder()
    }

    override func loadData() { }

    // MARK: - Private function
    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        searchTextField.font = helveticaFont.Light(17)
    }

    private func configPullToRefreshView() {
        searchResultTableView.pullToRefreshView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        searchResultTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
    }

    private func loadVideo(isRefresh: Bool) {
    }

    @IBAction private func dismissViewController(sender: UIButton) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: nil)
    }

}
extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlayerCell.getCellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(PlayerCell)
        cell.configCellAtIndex(indexPath.row)
        return cell
    }
}
