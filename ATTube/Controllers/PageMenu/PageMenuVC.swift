//
//  PageMenuVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import SwiftUtils
import RealmSwift
import PureLayout
import PagingMenuController

class PageMenuVC: ViewController {

    // MARK - Oulet
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    @IBOutlet private weak var homeIcon: UIImageView!
    @IBOutlet private weak var trendingIcon: UIImageView!
    @IBOutlet private weak var favoriteIcon: UIImageView!

    @IBOutlet weak var menuBarView: UIView!
    // MARK - Property

    private var controllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK - Init UI & Data
    override func configUI() {
        navigationController?.navigationBar.hidden = true
        let options = PagingMenuOptions()
        let pagingMenuController = PagingMenuController(options: options)
        pagingMenuController.delegate = self
        addChildViewController(pagingMenuController)
        menuBarView.addSubview(pagingMenuController.view)
        pagingMenuController.view.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        pagingMenuController.didMoveToParentViewController(self)
    }

    override func loadData() { }

    // MARK: - IBAction
    @IBAction private func showSearchVC(sender: UIButton) {
        let search = SearchVC.vc()
        navigationController?.pushViewController(search, animated: true)
    }
}
extension PageMenuVC: PagingMenuControllerDelegate {
    func willMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {

    }

    func didMoveToPageMenuController(menuController: UIViewController, previousMenuController: UIViewController) {
        titleLabel.text = menuController.title
    }
}

extension PageMenuVC: PlayerVCDelegate {
    func playVideo(index: Int?, InListVideos listVideos: List<Video>?, isShowPlaylist: Bool) {
        let player = PlayerVC(index: index, listVideos: listVideos, isShowPlaylist: isShowPlaylist)
        self.presentViewController(player, animated: true, completion: nil)
    }
}
