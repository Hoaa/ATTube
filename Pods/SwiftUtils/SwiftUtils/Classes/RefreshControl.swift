//
//  RefreshControl.swift
//  SwiftUtils
//
//  Created by DaoNV on 5/7/16.
//  Copyright © 2016 Astraler Technology. All rights reserved.
//

import UIKit

public class RefreshControl: UIRefreshControl {

    override public func endRefreshing() {
        let scrollView = superview as? UIScrollView
        let scrollEnabled = scrollView?.scrollEnabled ?? true
        scrollView?.scrollEnabled = false
        super.endRefreshing()
        scrollView?.scrollEnabled = scrollEnabled
    }

}
