//
//  TableView.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/5/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

public class TableView: UITableView {
    public var allowHeaderViewsToFloat: Bool = false
    public var allowFooterViewsToFloat: Bool = false

    public func allowsHeaderViewsToFloat() -> Bool {
        return allowHeaderViewsToFloat
    }

    public func allowsFooterViewsToFloat() -> Bool {
        return allowFooterViewsToFloat
    }
}
