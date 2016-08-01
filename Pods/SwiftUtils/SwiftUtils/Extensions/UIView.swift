//
//  UIView.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

public class IntrinsicContentView: UIView {
    public var intrinsicContentSizeEnabled = true
}

extension UIView {
    public static var nib: UINib {
        return UINib(nibName: String(self), bundle: nil)
    }
}

// MARK: Appearance
extension UIView {
    public func clear() {
        backgroundColor = UIColor.clearColor()
        for sub in subviews {
            sub.clear()
        }
    }

    public func border(color color: UIColor, width: CGFloat) {
        layer.borderColor = color.CGColor
        layer.borderWidth = width
        layer.cornerRadius = corner
        layer.masksToBounds = true
    }

    public var corner: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }

    public func circle() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
        layer.masksToBounds = true
    }

    public enum BorderPostition {
        case Top
        case Left
        case Bottom
        case Right
    }

    public func border(pos: BorderPostition, color: UIColor = UIColor.blackColor(), width: CGFloat = 0.5, insets: UIEdgeInsets = UIEdgeInsetsZero) {
        let rect: CGRect = {
            switch pos {
            case .Top: return CGRect(x: 0, y: 0, width: frame.width, height: width)
            case .Left: return CGRect(x: 0, y: 0, width: width, height: frame.height)
            case .Bottom: return CGRect(x: 0, y: frame.height - width, width: frame.width, height: width)
            case .Right: return CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
            }
        }()
        let border = UIView(frame: rect)
        border.backgroundColor = color
        border.autoresizingMask = {
            switch pos {
            case .Top: return [.FlexibleWidth, .FlexibleBottomMargin]
            case .Left: return [.FlexibleHeight, .FlexibleRightMargin]
            case .Bottom: return [.FlexibleWidth, .FlexibleTopMargin]
            case .Right: return [.FlexibleHeight, .FlexibleLeftMargin]
            }
        }()
        addSubview(border)
    }

    public func shadow(color color: UIColor, offset: CGSize = CGSize(width: 0, height: 0), opacity: Float = 1.0, radius: CGFloat = 3.0) {
        layer.shadowColor = color.CGColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
    }
}

// MARK: Layout
extension UIView {
    public func removeSubviewsConstraints() {
        removeConstraints(constraints.filter({ (constraint: NSLayoutConstraint) -> Bool in
            let first = constraint.firstItem as? UIView
            let second = constraint.secondItem as? UIView
            if (first == self && second == self) || (first == self && second == nil) || (first == nil && second == self) {
                return false
            }
            return true
            }))
        for sub in subviews {
            sub.translatesAutoresizingMaskIntoConstraints = false
            sub.removeAllConstraints()
        }
    }

    public func removeAllConstraints() {
        if let view = self as? IntrinsicContentView {
            if view.intrinsicContentSizeEnabled {
                return
            }
        }
        var parent = superview
        while parent != nil {
            for constraint in parent!.constraints {
                let first = constraint.firstItem as? UIView
                let second = constraint.secondItem as? UIView
                if first == self || second == self {
                    parent!.removeConstraint(constraint)
                }
            }
            parent = parent!.superview
        }
        removeConstraints(constraints)
        let subviews = self.subviews
        for sub in subviews {
            sub.removeAllConstraints()
        }
    }
}
