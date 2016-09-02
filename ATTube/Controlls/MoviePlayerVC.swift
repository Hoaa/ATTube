//
//  MoviePlayerVC.swift
//  ATTube
//
//  Created by Quang Phù on 8/24/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

protocol MoviePlayerVCDelegate {
    func playOtherVideo(isNext isNextVideo: Bool)
    func closePlayerViewController()
    func stopAnimationLoading()
    func fullScreen(isFullscreen flag: Bool)
}

enum Buttons: Int {
    case Previous = 1
    case Next
    case Play
}

private extension Selector {
    static let updateTime = #selector(MoviePlayerVC.updateTime)
    static let hiddenControlView = #selector(MoviePlayerVC.hiddenControlView)
    static let moviePlayerNowPlayingMovieDidChange = #selector(MoviePlayerVC.moviePlayerNowPlayingMovieDidChange(_:))
    static let moviePlayerPlaybackDidChange = #selector(MoviePlayerVC.moviePlayerPlaybackDidChange(_:))
    static let moviePlayerPlayBackDidFinish = #selector(MoviePlayerVC.moviePlayerPlayBackDidFinish(_:))
}

class MoviePlayerVC: ViewController {

    // MARK:- IBOutlet
    @IBOutlet private weak var playerVideoView: UIView!
    @IBOutlet private weak var controlView: UIView!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var beginTimeLabel: UILabel!
    @IBOutlet private weak var sliderTime: UISlider!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var fullScreenImageView: UIImageView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!

    // MARK:- Property
    private var youtubeVideoPlayer: XCDYouTubeVideoPlayerViewController?
    private var mediaPlayer: MPMoviePlayerController?
    private var timeUpdate: NSTimer?
    private var timeHiddenTool: NSTimer?
    private var isFullscreen = false
    private var isHiddenControlView = true

    var videoIdentifier: String?
    var delegate: MoviePlayerVCDelegate?

    init(videoIdentifier: String?) {
        super.init(nibName: "MoviePlayerVC", bundle: nil)
        self.videoIdentifier = videoIdentifier

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func configUI() {
        addNotification()
        footerView.addBlurBackground(.Light)
        controlView.hidden = isHiddenControlView
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if isHiddenControlView {
            timeHiddenTool?.invalidate()
            timeHiddenTool = NSTimer.scheduledTimerWithTimeInterval(3.0,
                target: self,
                selector: .hiddenControlView,
                userInfo: nil, repeats: false)
            controlView.hidden = false
            isHiddenControlView = false
        } else {
            hiddenControlView()
            isHiddenControlView = true
        }
    }

    override func loadData() { }

    // MARK:- Private function
    private func addNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: .moviePlayerNowPlayingMovieDidChange,
            name: Strings.mpMoviePlayerNowPlayingMovieDidChange,
            object: nil)

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: .moviePlayerPlaybackDidChange,
            name: Strings.mpMoviePlayerPlaybackStateDidChange,
            object: nil)
    }

    private func addPlaybackDidFinishNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: .moviePlayerPlayBackDidFinish,
            name: Strings.mpMoviePlayerPlaybackDidFinish,
            object: mediaPlayer)
    }

    private func deletePlaybackDidFinishNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: Strings.mpMoviePlayerPlaybackDidFinish,
            object: mediaPlayer
        )
    }

    private func configControlViewPlayblackFinished() {
        beginTimeLabel.text = Strings.undefinedTime
        endTimeLabel.text = Strings.undefinedTime
        sliderTime.value = 0
    }

    private func startAnimatingLoading() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        indicator?.startAnimating()
    }

    private func stopAnimatingLoading() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        indicator?.stopAnimating()
        delegate?.stopAnimationLoading()
    }

    private func convertIntervalTime(timeInterval: Int) -> (hour: Int, minute: Int, second: Int) {
        var time = timeInterval
        let hour = Int(time / 3600)
        time -= hour * 3600
        let minute = Int(time / 60)
        let second = Int(time - (minute * 60))
        return (hour, minute, second)
    }

    @objc private func updateTime() {
        guard let mediaPlayer = mediaPlayer else { return }
        let second = mediaPlayer.currentPlaybackTime
        if !second.isNaN {
            let currentTime = convertIntervalTime(Int(second))
            let stringMinnute = NSString(format: "%02d", currentTime.minute)
            let stringSecond = NSString(format: "%02d", currentTime.second)

            beginTimeLabel.text = currentTime.hour == 0 ? "\(stringMinnute):\(stringSecond)" : "\(currentTime.hour):\(stringMinnute):\(stringSecond)"

            var duration = mediaPlayer.duration
            duration -= second
            let remainingTime = convertIntervalTime(Int(duration))
            let hour = remainingTime.hour
            let min = NSString(format: "%02d", remainingTime.minute)
            let sec = NSString(format: "%02d", remainingTime.second)
            endTimeLabel.text = hour == 0 ? "\(min):\(sec)" : "\(hour):\(min):\(sec)"

            sliderTime.value = Float(second) / Float(duration + second)
        }
    }

    @objc private func hiddenControlView() {
        UIView.animateWithDuration(1.0, animations: {
            self.controlView.alpha = 0.0
        }) { (finish) in
            if finish {
                self.controlView.hidden = true
                self.controlView.alpha = 1.0
                self.isHiddenControlView = true
            }
        }
    }

    // MARK:- selector Notification
    @objc private func moviePlayerPlayBackDidFinish(notification: NSNotification) {
        print("moviePlayerPlayBackDidFinish")
        configControlViewPlayblackFinished()
        delegate?.playOtherVideo(isNext: true)
    }

    @objc private func moviePlayerNowPlayingMovieDidChange(notification: NSNotification) {
        print("moviePlayerNowPlayingMovieDidChange")
        stopAnimatingLoading()
    }

    @objc private func moviePlayerPlaybackDidChange(notification: NSNotification) {
        print("moviePlayerPlaybackDidChange")
        guard let mediaPlayer = mediaPlayer else { return }
        let state: MPMoviePlaybackState = mediaPlayer.playbackState
        switch state {

        case MPMoviePlaybackState.Stopped: print("stopped"); break

        case MPMoviePlaybackState.Interrupted: break

        case MPMoviePlaybackState.SeekingForward: break

        case MPMoviePlaybackState.SeekingBackward: break

        case MPMoviePlaybackState.Paused:
            print("paused")
            playButton.setBackgroundImage(UIImage(assetIdentifier: .Play), forState: .Normal)
            break

        case MPMoviePlaybackState.Playing:
            print("playing")
            playButton.setBackgroundImage(UIImage(assetIdentifier: .Pause), forState: .Normal)
            timeUpdate?.invalidate()
            timeHiddenTool?.invalidate()
            timeUpdate = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
                selector: .updateTime,
                userInfo: nil, repeats: true)
            timeHiddenTool = NSTimer.scheduledTimerWithTimeInterval(3.0,
                target: self,
                selector: .hiddenControlView,
                userInfo: nil, repeats: false)
            break
        }
    }

    // MARK:- Public
    func fetchVideo() {
        startAnimatingLoading()
        XCDYouTubeClient.defaultClient().getVideoWithIdentifier(videoIdentifier) {
            (video: XCDYouTubeVideo?, error: NSError?) in
            if error != nil {
                self.stopAnimatingLoading()
            }
            if let streamURL = video?.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ??
            video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] ??
            video?.streamURLs[XCDYouTubeVideoQuality.Medium360.rawValue] ??
            video?.streamURLs[XCDYouTubeVideoQuality.Small240.rawValue] {
                self.playVideoWithStreamURL(streamURL: streamURL)
            } else if !Reachability.isConnectedToNetwork() {
                Message.warning(Strings.warning, subTitle: Strings.networkFailedMessage)
            } else {
                Message.warning(Strings.warning, subTitle: Strings.fetchVideoFailedMessage)
            }
        }
    }

    private func playVideoWithStreamURL(streamURL streamURL: NSURL?) {
        deletePlaybackDidFinishNotification()
        mediaPlayer?.view.removeFromSuperview()
        mediaPlayer = nil

        mediaPlayer = MPMoviePlayerController(contentURL: streamURL)
        guard let mediaPlayer = mediaPlayer else { return }
        mediaPlayer.controlStyle = .None
        mediaPlayer.play()
        view.addSubview(mediaPlayer.view)
        mediaPlayer.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        view.bringSubviewToFront(controlView)
        view.bringSubviewToFront(indicator)
        addPlaybackDidFinishNotification()
    }

    func releaseObjectBeforeDeinit() {
        stopAnimatingLoading()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        mediaPlayer?.stop()
        mediaPlayer?.view.removeFromSuperview()
        mediaPlayer = nil
    }

    // MARK:- Public
    func updateIconFullScreen(isFullscreen flag: Bool) {
        if flag {
            fullScreenImageView.image = UIImage(assetIdentifier: .NonExpand)
        } else {
            fullScreenImageView.image = UIImage(assetIdentifier: .Expand)
        }
    }

    // MARK:- IBOutlet
    @IBAction private func didTapCloseButton(sender: UIButton) {
        delegate?.closePlayerViewController()
    }

    @IBAction private func didTapFullScreenButton(sender: UIButton) {
        isFullscreen = !isFullscreen
        updateIconFullScreen(isFullscreen: isFullscreen)
        delegate?.fullScreen(isFullscreen: isFullscreen)
    }

    @IBAction private func didTapChangeStateVideoButton(sender: UIButton) {
        guard let buttonItem = Buttons(rawValue: sender.tag) else {
            return
        }
        switch buttonItem {
        case .Next:
            delegate?.playOtherVideo(isNext: true)
            break
        case .Previous:
            delegate?.playOtherVideo(isNext: false)
            break
        case .Play:
            guard let mediaPlayer = mediaPlayer else { return }
            switch mediaPlayer.playbackState {
            case .Playing:
                mediaPlayer.pause()
            case .Paused:
                mediaPlayer.play()
            default:
                break
            }
        }
    }

    @IBAction func playbackAtSliderTime(sender: UISlider) {
        guard let mediaPlayer = mediaPlayer else { return }
        timeUpdate?.invalidate()
        mediaPlayer.currentPlaybackTime = Double(Double(sliderTime.value) * mediaPlayer.duration)
        let secondPlay = NSInteger(Double(sliderTime.value) * mediaPlayer.duration % 60)
        let stringsSecond = NSString(format: "%02d", NSInteger(secondPlay))
        let min = NSInteger(Double(sliderTime.value) * Double(mediaPlayer.duration) / 60) % 60
        beginTimeLabel.text = "\(min):\(stringsSecond)"
        timeUpdate = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
            selector: .updateTime,
            userInfo: nil, repeats: true)
    }
}
