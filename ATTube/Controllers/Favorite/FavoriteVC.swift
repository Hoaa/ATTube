//
//  FavoriteVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/1/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import PZPullToRefresh

protocol NavigationBarDelegate {
	func hideNavigationBar(viewController: ViewController)
	func showNavigationBar(viewController: ViewController)
}

class FavoriteVC: ViewController {

	// MARK:- Outlet
	@IBOutlet weak var tableView: UITableView!

	// MARK: - Propery
	private var refreshHeaderView: PZPullToRefreshView?
	var delegate: NavigationBarDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()

	}

	// MARK - Init UI & Data
	override func configUI() {
		tableView.registerNib(FavoriteCell)

		// Init refresh header view
		if refreshHeaderView == nil {
			let view = PZPullToRefreshView(frame: CGRect(x: 0,
				y: 0 - tableView.bounds.size.height,
				width: tableView.bounds.size.width,
				height: tableView.bounds.size.height))
			view.delegate = self
			tableView.addSubview(view)
			refreshHeaderView = view
			refreshHeaderView?.backgroundColor = Color.refreshHeaderView
		}
	}

	override func loadData() {
	}
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension FavoriteVC: UITableViewDataSource, UITableViewDelegate {

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 10
	}

	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let favorite = tableView.dequeue(FavoriteCell)
		favorite.index = indexPath.row
//		favorite.initProtocal(self)
		favorite.collectionView.delegate = self
		favorite.collectionView.dataSource = self
		let nib = UINib(nibName: "FavoriteCollectionCell", bundle: nil)
		favorite.collectionView.registerNib(nib, forCellWithReuseIdentifier: "FavoriteCollectionCell")
		favorite.setBackgroundColorForContentView()
		return favorite
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return getCellHeight()
	}

	func getCellHeight() -> CGFloat {
		return Size.favoriteCellHeight * Ratio.horizontal
	}
}

extension FavoriteVC: UICollectionViewDelegate, UICollectionViewDataSource {

	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		return collectionView.dequeueReusableCellWithReuseIdentifier("FavoriteCollectionCell",
			forIndexPath: indexPath)
	}
}

extension FavoriteVC: UICollectionViewDelegateFlowLayout {
	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			return CGSize(width: Ratio.vertical * 180, height: collectionView.bounds.size.height)
	}

	func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
			return UIEdgeInsets(top: 0,
				left: 5,
				bottom: 0,
				right: 5)
	}

	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {

			return 5
	}
}

// MARK:UIScrollViewDelegate
extension FavoriteVC: UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {

		refreshHeaderView?.refreshScrollViewDidScroll(scrollView)
		print("scrollViewDidScroll \(scrollView.contentOffset.y)")
	}

	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		refreshHeaderView?.refreshScrollViewDidEndDragging(scrollView)
	}
}

// MARK: - PZPullToRefreshDelegate
extension FavoriteVC: PZPullToRefreshDelegate {

	func pullToRefreshDidTrigger(view: PZPullToRefreshView) -> () {
		refreshHeaderView?.isLoading = true

		let delay = 3.0 * Double(NSEC_PER_SEC)
		let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
		dispatch_after(time, dispatch_get_main_queue(), {
			print("Complete loading!")

			self.refreshHeaderView?.isLoading = false
			self.refreshHeaderView?.refreshScrollViewDataSourceDidFinishedLoading(self.tableView)
		})
	}

	func pullToRefreshLastUpdated(view: PZPullToRefreshView) -> NSDate {
		return NSDate()
	}
}
