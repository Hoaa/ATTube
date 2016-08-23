//
//  PlayerVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/8/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SVPullToRefresh
import RealmSwift

protocol PlayerVCDelegate {
    func playVideo(index: Int?, InPlaylist playList: Playlist?, isShowPlaylist: Bool)
}

private extension Selector {
    static let longPressGestureRecognized = #selector(PlayerVC.longPress(_:))
}

class PlayerVC: ViewController {

    @IBOutlet private weak var videosTableView: UITableView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var totalViewsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var showDescriptionButton: UIButton!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var showMoreButton: UIButton!

    private var indexPlayingVideo: Int = 0
    private var playlist: Playlist?
    private var relatedVideos: [Video]?
    private var isShowPlaylist = false
    private var isExpand = false

    init(index: Int?, playlist: Playlist?, isShowPlaylist: Bool) {
        super.init(nibName: "PlayerVC", bundle: nil)
        self.isShowPlaylist = isShowPlaylist
        self.playlist = playlist
        indexPlayingVideo = index ?? 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateContentViewFrame()
        reloadSectionIndexTitles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    override func configUI() {
        autoFontSize()
        loadDataForPlayingVideo(playlist?.videos[indexPlayingVideo])

        videosTableView.registerNib(PlayerCell)
        videosTableView.dataSource = self
        videosTableView.delegate = self
        if !isShowPlaylist {
            videosTableView.addInfiniteScrollingWithActionHandler {
                self.handleLoadMore()
            }
            configPullToRefreshView()
        }

        let longPress = UILongPressGestureRecognizer(target: self, action: .longPressGestureRecognized)
        videosTableView.addGestureRecognizer(longPress)
    }

    override func loadData() { }

    // MARK: - Private function
    private func configPullToRefreshView() {
        videosTableView.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
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

    private func loadDataForPlayingVideo(playingVideo: Video?) {
        if let thumbnailURLString = playingVideo?.highThumbnailURL, thumbnailURL = NSURL(string: thumbnailURLString) {
            thumbnailImageView.sd_setImageWithURL(thumbnailURL, placeholderImage: UIImage(assetIdentifier: .BgHomeCell))
        }
        videoNameLabel.text = playingVideo?.title
        totalViewsLabel.text = HandleData.viewCount(playingVideo?.viewCount)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.text = playingVideo?.describe
        isExpand = false
    }

    private func reloadSectionIndexTitles() {
        videosTableView.beginUpdates()
        videosTableView.reloadSectionIndexTitles()
        videosTableView.endUpdates()
    }

    private func deleteVideoAt(index: Int) {
        guard let video = playlist?.videos[index] else { return }
        if playlist?.deleteVideo(video) == true {
            videosTableView.beginUpdates()
            videosTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
            videosTableView.endUpdates()

            NSNotificationCenter.defaultCenter().postNotificationName(Strings.notificationUpdatePlaylist, object: nil)

            if playlist?.videos.count == 0 {
                dismissViewControllerAnimated(true, completion: nil)
                return
            }
            if indexPlayingVideo == index {
                loadDataForPlayingVideo(playlist?.videos[0])
            }
            Alert.sharedInstance.showAlert(self, title: Strings.success, message: Strings.deleteVideoSuccessMessage)
        } else {
            Alert.sharedInstance.showAlert(self, title: Strings.failure, message: Strings.deleteVideoFailureMessage)
        }
    }

    private func updateContentViewFrame() {
        contentView.frame.size = CGSize(width: contentView.width,
            height: 1 * Ratio.widthIPhone6 + videoNameLabel.height + totalViewsLabel.height + descriptionLabel.height + showMoreButton.height)
    }

    @objc private func longPress(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as? UILongPressGestureRecognizer
        let statePress = longPress?.state
        let location = longPress?.locationInView(videosTableView)
        guard let state = statePress,
            locationInView = location,
            indexPath = videosTableView.indexPathForRowAtPoint(locationInView),
            playlist = playlist else { return }

        struct MyView {
            static var cellSnapshot: UIView? = nil
            static var cellIsAnimating: Bool = false
            static var cellNeedToShow: Bool = false
        }

        struct Path {
            static var initialIndexPath: NSIndexPath? = nil
        }

        switch state {
        case .Began:
            Path.initialIndexPath = indexPath
            let cell = videosTableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
            MyView.cellSnapshot = snapshotOfCell(cell)

            var center = cell.center
            MyView.cellSnapshot!.center = center
            MyView.cellSnapshot!.alpha = 0.0
            videosTableView.addSubview(MyView.cellSnapshot!)

            UIView.animateWithDuration(0.25, animations: { () -> Void in
                center.y = locationInView.y
                MyView.cellIsAnimating = true
                MyView.cellSnapshot!.center = center
                MyView.cellSnapshot!.transform = CGAffineTransformMakeScale(1.05, 1.05)
                MyView.cellSnapshot!.alpha = 0.98
                cell.alpha = 0.0
                }, completion: { (finished) -> Void in
                if finished {
                    MyView.cellIsAnimating = false
                    if MyView.cellNeedToShow {
                        MyView.cellNeedToShow = false
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            cell.alpha = 1
                        })
                    } else {
                        cell.hidden = true
                    }
                }
            })
        case .Changed:
            if MyView.cellSnapshot != nil {
                var center = MyView.cellSnapshot!.center
                center.y = locationInView.y
                MyView.cellSnapshot!.center = center

                guard let firstIndex = Path.initialIndexPath?.row else { break }
                if firstIndex != indexPath.row {
                    if playlist.swapVideo(firstIndex, index2: indexPath.row) {
                        videosTableView.moveRowAtIndexPath(Path.initialIndexPath!, toIndexPath: indexPath)
                        Path.initialIndexPath = indexPath
                        NSNotificationCenter.defaultCenter().postNotificationName(Strings.notificationUpdatePlaylist, object: nil)
                    }
                }
            }
        default:
            if Path.initialIndexPath != nil {
                let cell = videosTableView.cellForRowAtIndexPath(Path.initialIndexPath!) as UITableViewCell!
                if MyView.cellIsAnimating {
                    MyView.cellNeedToShow = true
                } else {
                    cell.hidden = false
                    cell.alpha = 0.0
                }

                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    MyView.cellSnapshot!.center = cell.center
                    MyView.cellSnapshot!.transform = CGAffineTransformIdentity
                    MyView.cellSnapshot!.alpha = 0.0
                    cell.alpha = 1.0

                    }, completion: { (finished) -> Void in
                    if finished {
                        Path.initialIndexPath = nil
                        MyView.cellSnapshot!.removeFromSuperview()
                        MyView.cellSnapshot = nil
                    }
                })
            }
        }
    }

    private func snapshotOfCell(inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()

        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

    // MARK:- IBAction
    @IBAction private func dismissViewController(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTapShowDecription(sender: AnyObject) {
        showDescription(nil)
    }

    private func showDescription(flag: Bool?) {
        let direction: CGFloat = flag ?? isExpand == false ? (180.0 * CGFloat(M_PI)) : (360.0 * CGFloat(M_PI))
        UIView.animateWithDuration(0.3, animations: {
            self.showDescriptionButton.transform = CGAffineTransformMakeRotation(direction / 180)
            self.descriptionLabel.numberOfLines = flag ?? self.isExpand == false ? 0 : 2
            self.descriptionLabel.sizeToFit()
            self.updateContentViewFrame()
            self.reloadSectionIndexTitles()
        }) { (finish) in
        }
        showMoreButton.setTitle(flag ?? self.isExpand ? Strings.showMore : Strings.showLess, forState: .Normal)
        isExpand = !(flag ?? isExpand)
    }
}

// MARK: - UITableviewDataSource, UITableViewDelegate
extension PlayerVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return descriptionLabel.height
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UILabel()
        headerView.backgroundColor = UIColor.clearColor()
        return headerView
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.videos.count ?? 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlayerCell.getCellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let video = playlist?.videos[indexPath.row]
        let playerCell = tableView.dequeue(PlayerCell)
        playerCell.configCellAtIndex(indexPath.row, object: video)
        return playerCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexPlayingVideo = indexPath.row
        showDescription(true)
        loadDataForPlayingVideo(playlist?.videos[indexPath.row])
    }

// Action for cell
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return isShowPlaylist
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            deleteVideoAt(indexPath.row)
        default: return
        }
    }
}
