//
//  PageMenuVC.swift
//  ATTube
//
//  Created by Asiantech1 on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit
import PageMenu
import SwiftUtils

class PageMenuVC: ViewController {

    // MARK - Oulet
    @IBOutlet private weak var menu: UIView!
    @IBOutlet private weak var navigationTitle: UILabel!

    @IBOutlet private weak var homeIcon: UIImageView!
    @IBOutlet private weak var trendingIcon: UIImageView!
    @IBOutlet private weak var favoriteIcon: UIImageView!

    // MARK - Property
    private var pageMenu: CAPSPageMenu?
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

        let homeVC = HomeVC.vc()
        let trendingVC = TrendingVC.vc()
        let favoriteVC = FavoriteVC.vc()

        // Set title for viewcontroller
        homeVC.title = ""
        trendingVC.title = ""
        favoriteVC.title = ""

        // Add into array
        controllers.append(homeVC)
        controllers.append(trendingVC)
        controllers.append(favoriteVC)

        let parameters: [CAPSPageMenuOption] = [
                .MenuItemSeparatorWidth(0),
                .MenuItemSeparatorPercentageHeight(0.1),
                .SelectionIndicatorColor(Color.selectionIndicator),
                .MenuItemSeparatorColor(Color.clear),
                .ScrollMenuBackgroundColor(Color.clear),
                .ViewBackgroundColor(Color.clear),
                .BottomMenuHairlineColor(Color.clear),
                .MenuMargin(0),
                .MenuItemWidth(Size.menuItemWidth),
                .MenuHeight(Size.menuHeight),
                .SelectionIndicatorHeight(Size.selectionIndicatorHeight)
        ]

        let yPageMenu = menu.bounds.height + menu.frame.origin.y - Size.menuHeight + Size.selectionIndicatorHeight
        pageMenu = CAPSPageMenu(viewControllers: controllers,
            frame: CGRect(origin: CGPoint(x: 0, y: yPageMenu), size: view.bounds.size),
            pageMenuOptions: parameters)
        pageMenu?.delegate = self

        if let menuView = pageMenu?.view {
            view.addSubview(menuView)
        }
    }

    override func loadData() {
    }

    // Mark - Private function
    private func moveToMenuItemAt(index: Int) {
        switch index {
        case 0:
            homeIcon.image = UIImage(assetIdentifier: .HomeActive)
            trendingIcon.image = UIImage(assetIdentifier: .Trending)
            favoriteIcon.image = UIImage(assetIdentifier: .Favorite)
            navigationTitle.text = Strings.homeTitle
        case 1:
            homeIcon.image = UIImage(assetIdentifier: .Home)
            trendingIcon.image = UIImage(assetIdentifier: .TrendingActive)
            favoriteIcon.image = UIImage(assetIdentifier: .Favorite)
            navigationTitle.text = Strings.trendingTitle
        case 2:
            homeIcon.image = UIImage(assetIdentifier: .Home)
            trendingIcon.image = UIImage(assetIdentifier: .Trending)
            favoriteIcon.image = UIImage(assetIdentifier: .FavoriteActive)
            navigationTitle.text = Strings.favoriteTitle
        default: break
        }
    }
}

extension PageMenuVC: CAPSPageMenuDelegate {

    func willMoveToPage(controller: UIViewController, index: Int) {
        moveToMenuItemAt(index)
    }

    func didMoveToPage(controller: UIViewController, index: Int) {

    }
}
