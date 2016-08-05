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

private extension CGFloat {
    static let menuHeight: CGFloat = 44
    static let menuItemWidth: CGFloat = kScreenSize.width / 3
    static let selectionIndicatorHeight: CGFloat = 4
}

enum MenuItems: Int {
    case Home = 0
    case Trending = 1
    case Favorite = 2
}

class PageMenuVC: ViewController {

    // MARK - Oulet
    @IBOutlet private weak var menuView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

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
                .SelectionIndicatorColor(Color.yellow),
                .MenuItemSeparatorColor(Color.clear),
                .ScrollMenuBackgroundColor(Color.clear),
                .ViewBackgroundColor(Color.clear),
                .BottomMenuHairlineColor(Color.clear),
                .MenuMargin(0),
                .MenuItemWidth(CGFloat.menuItemWidth),
                .MenuHeight(CGFloat.menuHeight),
                .SelectionIndicatorHeight(CGFloat.selectionIndicatorHeight)
        ]

        let yPageMenu = menuView.height + menuView.originY - CGFloat.menuHeight + CGFloat.selectionIndicatorHeight
        let pageMenuSize = CGSize(width: view.width, height: 603 * Ratio.widthIPhone6)
        pageMenu = CAPSPageMenu(viewControllers: controllers,
            frame: CGRect(origin: CGPoint(x: 0, y: yPageMenu), size: pageMenuSize),
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
        guard let menuItem = MenuItems(rawValue: index) else {
            return
        }
        switch menuItem {
        case .Home:
            homeIcon.image = UIImage(assetIdentifier: .HomeActive)
            trendingIcon.image = UIImage(assetIdentifier: .Trending)
            favoriteIcon.image = UIImage(assetIdentifier: .Favorite)
            titleLabel.text = Strings.homeTitle
        case .Trending:
            homeIcon.image = UIImage(assetIdentifier: .Home)
            trendingIcon.image = UIImage(assetIdentifier: .TrendingActive)
            favoriteIcon.image = UIImage(assetIdentifier: .Favorite)
            titleLabel.text = Strings.trendingTitle
        case .Favorite:
            homeIcon.image = UIImage(assetIdentifier: .Home)
            trendingIcon.image = UIImage(assetIdentifier: .Trending)
            favoriteIcon.image = UIImage(assetIdentifier: .FavoriteActive)
            titleLabel.text = Strings.favoriteTitle

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
