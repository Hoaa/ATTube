//
//  UIEdgeInsets.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    public init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    public var inverse: UIEdgeInsets {
        return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
    }

    public func inset(rect: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(rect, self)
    }

    public var isZero: Bool {
        return top == 0 && left == 0 && bottom == 0 && right == 0
    }
}

public func + (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    var insets = lhs
    insets.top += rhs
    insets.left += rhs
    insets.bottom += rhs
    insets.right += rhs
    return insets
}

public func - (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    var insets = lhs
    insets.top -= rhs
    insets.left -= rhs
    insets.bottom -= rhs
    insets.right -= rhs
    return insets
}

public func * (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    var insets = lhs
    insets.top *= rhs
    insets.left *= rhs
    insets.bottom *= rhs
    insets.right *= rhs
    return insets
}

public func / (lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    var insets = lhs
    insets.top /= rhs
    insets.left /= rhs
    insets.bottom /= rhs
    insets.right /= rhs
    return insets
}

public func += (inout lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    lhs.top += rhs
    lhs.left += rhs
    lhs.bottom += rhs
    lhs.right += rhs
    return lhs
}

public func -= (inout lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    lhs.top -= rhs
    lhs.left -= rhs
    lhs.bottom -= rhs
    lhs.right -= rhs
    return lhs
}

public func *= (inout lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    lhs.top *= rhs
    lhs.left *= rhs
    lhs.bottom *= rhs
    lhs.right *= rhs
    return lhs
}

public func /= (inout lhs: UIEdgeInsets, rhs: CGFloat) -> UIEdgeInsets {
    lhs.top /= rhs
    lhs.left /= rhs
    lhs.bottom /= rhs
    lhs.right /= rhs
    return lhs
}
