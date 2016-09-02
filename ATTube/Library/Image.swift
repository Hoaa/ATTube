//
//  Image.swift
//  ATTube
//
//  Created by Asiantech1 on 8/2/16.
//  Copyright © 2016 at. All rights reserved.
//

import UIKit

extension UIImage {

    enum AssetIdentifier: String {
        case Home, HomeActive, Trending, TrendingActive, Favorite, FavoriteActive, BgNavigation, Search, BgHomeCell, Play, Pause, Expand, NonExpand
    }

    convenience init!(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }

}
