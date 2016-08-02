//
//  UITableView.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

extension UITableView {
    override public var delaysContentTouches: Bool {
        didSet {
            for view in subviews {
                if let scroll = view as? UIScrollView {
                    scroll.delaysContentTouches = delaysContentTouches
                }
                break
            }
        }
    }

    public func setSeparatorInsets(insets: UIEdgeInsets) {
        separatorInset = insets
        layoutMargins = insets
    }

    public func scrollsToBottom(animated: Bool) {
        let section = numberOfSections - 1
        let row = numberOfRowsInSection(section) - 1
        if section < 0 || row < 0 {
            return
        }
        let path = NSIndexPath(forRow: row, inSection: section)
        let offset = contentOffset.y
        scrollToRowAtIndexPath(path, atScrollPosition: .Top, animated: animated)
        let delay = (animated ? 0.2 : 0.0) * Double(NSEC_PER_SEC)
        let t = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(t, dispatch_get_main_queue(), { () -> Void in
            if self.contentOffset.y != offset {
                self.scrollsToBottom(false)
            }
        })
    }

    public func registerNib<T: UITableViewCell>(aClass: T.Type) {
        let name = String(aClass)
        let nib = UINib(nibName: name, bundle: nil)
        registerNib(nib, forCellReuseIdentifier: name)
    }

    public func registerClass<T: UITableViewCell>(aClass: T.Type) {
        let name = String(aClass)
        registerClass(aClass, forCellReuseIdentifier: name)
    }

    public func registerNib<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let name = String(aClass)
        let nib = UINib(nibName: name, bundle: nil)
        registerNib(nib, forHeaderFooterViewReuseIdentifier: name)
    }

    public func registerClass<T: UITableViewHeaderFooterView>(aClass: T.Type) {
        let name = String(aClass)
        registerClass(aClass, forHeaderFooterViewReuseIdentifier: name)
    }

    public func dequeue<T: UITableViewCell>(aClass: T.Type) -> T! {
        let name = String(aClass)
        guard let cell = dequeueReusableCellWithIdentifier(name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }

    public func dequeue<T: UITableViewHeaderFooterView>(aClass: T.Type) -> T! {
        let name = String(aClass)
        guard let cell = dequeueReusableHeaderFooterViewWithIdentifier(name) as? T else {
            fatalError("\(name) is not registed")
        }
        return cell
    }
}

extension UITableViewCell {
    public func setSeparatorInsets(insets: UIEdgeInsets) {
        separatorInset = insets
        layoutMargins = insets
    }
}
