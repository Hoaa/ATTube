//
//  TrendingVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import PZPullToRefresh

class TrendingVC: ViewController {

	// MARK: - Outlet
	@IBOutlet private weak var videosTableView: UITableView!

	// MARK: - Propery
	private var refreshHeaderView: PZPullToRefreshView?

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	// MARK - Init UI & Data
	override func configUI() {
		// Register xib for cell
		let nib = UINib(nibName: Strings.trendingCellNibName, bundle: nil)
		videosTableView.registerNib(nib, forCellReuseIdentifier: Strings.trendingCellReuseIdentifier)

		// Init refresh header view
		if refreshHeaderView == nil {
			let view = PZPullToRefreshView(frame: CGRect(x: 0,
				y: 0 - videosTableView.bounds.size.height,
				width: videosTableView.bounds.size.width,
				height: videosTableView.bounds.size.height))
			view.delegate = self
			videosTableView.addSubview(view)
			refreshHeaderView = view
			refreshHeaderView?.backgroundColor = Color.refreshHeaderView
		}

	}

	override func loadData() {
	}

}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension TrendingVC: UITableViewDataSource, UITableViewDelegate {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let trendingCell = tableView.dequeueReusableCellWithIdentifier(Strings.trendingCellReuseIdentifier, forIndexPath: indexPath) as? TrendingCell
		trendingCell?.index = indexPath.row
		trendingCell?.setBackgroundColorForContentView()
		return trendingCell ?? TrendingCell()
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return getCellHeight()
	}

	func getCellHeight() -> CGFloat {
		return Size.homeCellHeight * Ratio.widthIPhone6
	}
}

// MARK:UIScrollViewDelegate
extension TrendingVC: UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
	}

	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
	}
}

// MARK: - PZPullToRefreshDelegate
extension TrendingVC: PZPullToRefreshDelegate {

	func pullToRefreshDidTrigger(view: PZPullToRefreshView) -> () {
		refreshHeaderView?.isLoading = true

		let delay = 3.0 * Double(NSEC_PER_SEC)
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
		dispatch_after(time, dispatch_get_main_queue(), {
			print("Complete loading!")

			self.refreshHeaderView?.isLoading = false
			self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.videosTableView)
		})
	}

	func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate {
		return NSDate()
	}
}
