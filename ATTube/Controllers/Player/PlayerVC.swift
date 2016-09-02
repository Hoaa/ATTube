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
import XCDYouTubeKit
import PureLayout

protocol PlayerVCDelegate {
    func playVideo(index: Int?, InListVideos listVideos: List<Video>?, isShowPlaylist: Bool)
}

@objc protocol UpdatePlaylistDelegate {
    func deleteVideoAt(index: Int)
    optional func deleteVideo(videoIdentifer: String)
    func swapVideo(firstIndex: Int, secondIndex: Int)
    func deletePlaylist()
}

private extension Selector {
    static let longPressGestureRecognized = #selector(PlayerVC.longPress(_:))
    static let rotated = #selector(PlayerVC.rotated)
}

struct MyView {
    static var cellSnapshot: UIView? = nil
    static var cellIsAnimating: Bool = false
    static var cellNeedToShow: Bool = false
}

struct Path {
    static var initialIndexPath: NSIndexPath? = nil
}

class PlayerVC: ViewController {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var playVideoView: UIView!
    @IBOutlet private weak var videosTableView: UITableView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var totalViewsLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var showDescriptionButton: UIButton!
    @IBOutlet private weak var showMoreButton: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    private var moviePlayerVC: MoviePlayerVC?
    private var listVideos: List<Video>?
    private var indexPlayingVideo: Int = 0
    private var isShowPlaylist = false
    private var isExpand = false
    private var isFullScreen = false
    private var nextPageToken: String?
    private var limit = 10

    var delegate: UpdatePlaylistDelegate?

    init(index: Int?, listVideos: List<Video>?, isShowPlaylist: Bool) {
        super.init(nibName: "PlayerVC", bundle: nil)
        self.isShowPlaylist = isShowPlaylist
        self.listVideos = listVideos
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
        moveToSelectedCell(indexPlayingVideo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK - Init UI & Data
    private func configMoviePlayerViewController() {
        moviePlayerVC = MoviePlayerVC(videoIdentifier: listVideos?[indexPlayingVideo].id)

        guard let moviePlayerVC = moviePlayerVC, video = listVideos?[indexPlayingVideo] else { return }
        moviePlayerVC.delegate = self
        moviePlayerVC.fetchVideo()
        playVideoView.addSubview(moviePlayerVC.view)
        moviePlayerVC.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        indicator.startAnimating()
        addChildViewController(moviePlayerVC)
        loadDataForPlayingVideo(video)
    }

    override func configUI() {
        addNotification()
        autoFontSize()

        videosTableView.registerNib(PlayerCell)
        videosTableView.dataSource = self
        videosTableView.delegate = self
        if isShowPlaylist {
            let longPress = UILongPressGestureRecognizer(target: self, action: .longPressGestureRecognized)
            videosTableView.addGestureRecognizer(longPress)
        } else {
            videosTableView.addInfiniteScrollingWithActionHandler {
                self.handleLoadMore()
            }
            configPullToRefreshView()
        }
    }

    override func loadData() {
        configMoviePlayerViewController()
        handleLoadMore()
    }

    // MARK:- Notification function
    @objc private func rotated() {
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            portraitDevice()
            isFullScreen = false
        case .LandscapeLeft, .LandscapeRight, .PortraitUpsideDown:
            isFullScreen = true
            landscapeDevice()
        default: break
        }
        moviePlayerVC?.updateIconFullScreen(isFullscreen: isFullScreen)
    }

    @objc private func longPress(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as? UILongPressGestureRecognizer
        let statePress = longPress?.state
        let location = longPress?.locationInView(videosTableView)
        guard let state = statePress,
            locationInView = location,
            indexPath = videosTableView.indexPathForRowAtPoint(locationInView)
        else { return }

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
                    if firstIndex == indexPlayingVideo {
                        indexPlayingVideo = indexPath.row
                    }
                    guard let initialIndexPath = Path.initialIndexPath else { return }
                    delegate?.swapVideo(initialIndexPath.row, secondIndex: indexPath.row)
                    videosTableView.moveRowAtIndexPath(initialIndexPath, toIndexPath: indexPath)
                    Path.initialIndexPath = indexPath
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

    // MARK: - Private function
    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: .rotated,
            name: UIDeviceOrientationDidChangeNotification, object: nil)
    }

    private func configPullToRefreshView() {
        videosTableView.infiniteScrollingView.activityIndicatorViewStyle = .White
    }

    private func handleLoadMore() { }

    private func autoFontSize() {
        let helveticaFont = HelveticaFont()
        videoNameLabel.font = helveticaFont.Regular(20)
        totalViewsLabel.font = helveticaFont.Light(14)
        descriptionLabel.font = helveticaFont.Regular(14)
    }

    private func loadDataForPlayingVideo(video: Video?) {
        guard let playingVideo = video else { return }
        videoNameLabel.text = playingVideo.title
        totalViewsLabel.text = HandleData.viewCount(playingVideo.viewCount)
        descriptionLabel.text = playingVideo.describe
        descriptionLabel.numberOfLines = 2
        isExpand = false
    }

    private func reloadSectionIndexTitles() {
        videosTableView.beginUpdates()
        videosTableView.reloadSectionIndexTitles()
        videosTableView.endUpdates()
    }

    private func deleteVideoAt(index: Int) {
        // Delete video in realm
        delegate?.deleteVideoAt(index)

        videosTableView.beginUpdates()
        videosTableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Fade)
        videosTableView.endUpdates()

        if listVideos?.count == 0 {
            closePlayerViewController()
            return
        }

        if indexPlayingVideo == index {
            indexPlayingVideo = 0
            playVideo()
            moveToSelectedCell(indexPlayingVideo)
        }
    }

    private func moveToSelectedCell(index: Int) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        videosTableView.selectRowAtIndexPath(indexPath,
            animated: true,
            scrollPosition: UITableViewScrollPosition.Middle)
        videosTableView.scrollToRowAtIndexPath(indexPath,
            atScrollPosition: .Middle,
            animated: true)
    }

    private func updateContentViewFrame() {
        guard let contentView = contentView else { return }
        contentView.frame.size = CGSize(width: contentView.width,
            height: 1 * Ratio.widthIPhone6 + videoNameLabel.height + totalViewsLabel.height + descriptionLabel.height + showMoreButton.height)
        reloadSectionIndexTitles()
    }

    private func landscapeDevice() {
        guard let moviePlayerView = moviePlayerVC?.view else { return }
        moviePlayerView.removeFromSuperview()
        view.addSubview(moviePlayerView)
        moviePlayerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        view.bringSubviewToFront(moviePlayerView)
    }

    private func portraitDevice() {
        guard let moviePlayerView = moviePlayerVC?.view else { return }
        moviePlayerView.removeFromSuperview()
        playVideoView.addSubview(moviePlayerView)
        moviePlayerView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

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

    private func showDescription(flag: Bool?) {
        let direction: CGFloat = flag ?? isExpand == false ? (180.0 * CGFloat(M_PI)) : (360.0 * CGFloat(M_PI))
        UIView.animateWithDuration(0.3, animations: {
            self.showDescriptionButton.transform = CGAffineTransformMakeRotation(direction / 180)
            self.descriptionLabel.numberOfLines = flag ?? self.isExpand == false ? 0 : 2
            self.descriptionLabel.sizeToFit()
            self.updateContentViewFrame()
        }) { (finish) in
        }
        showMoreButton.setTitle(flag ?? self.isExpand ? Strings.showMore : Strings.showLess, forState: .Normal)
        isExpand = !(flag ?? isExpand)
    }

    private func playVideo() {
        if indexPlayingVideo >= listVideos?.count { return }
        showDescription(true)
        moviePlayerVC?.videoIdentifier = listVideos?[indexPlayingVideo].id
        moviePlayerVC?.fetchVideo()
        loadDataForPlayingVideo(listVideos?[indexPlayingVideo])
    }

    // MARK:- IBAction
    @IBAction func didTapShowDecription(sender: AnyObject) {
        showDescription(nil)
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
        return listVideos?.count ?? 0
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return PlayerCell.getCellHeight()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let video = listVideos?[indexPath.row]
        let playerCell = tableView.dequeue(PlayerCell)
        playerCell.configCellAtIndex(indexPath.row, object: video)
        return playerCell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexPlayingVideo = indexPath.row
        moveToSelectedCell(indexPlayingVideo)
        playVideo()
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

extension PlayerVC: MoviePlayerVCDelegate {
    func stopAnimationLoading() {
        indicator.stopAnimating()
    }

    func playOtherVideo(isNext isNextVideo: Bool) {
        guard let listVideos = listVideos else { return }
        if isShowPlaylist {
            if isNextVideo {
                if indexPlayingVideo == listVideos.count - 1 { return }
                indexPlayingVideo += 1
            } else {
                indexPlayingVideo = indexPlayingVideo == 0 ? 0 : indexPlayingVideo - 1
            }
            moveToSelectedCell(indexPlayingVideo)
            playVideo()
        } else {

        }
    }

    func closePlayerViewController() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        moviePlayerVC?.releaseObjectBeforeDeinit()
        dismissViewControllerAnimated(true, completion: nil)
    }

    func fullScreen(isFullscreen flag: Bool) {
        if flag {
            landscapeDevice()
        } else {
            portraitDevice()
        }
    }
}
