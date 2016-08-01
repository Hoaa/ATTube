//
//  Type.swift
//  SwiftUtils
//
//  Created by DaoNV on 12/30/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

public typealias JSObject = [String: AnyObject]
public typealias JSArray = [JSObject]

public enum DeviceType: Int {
    case Phone4
    case Phone5
    case Phone6
    case Phone6p
    case Pad

    public var size: CGSize {
        switch self {
        case .Phone4: return CGSize(width: 320, height: 480)
        case .Phone5: return CGSize(width: 320, height: 568)
        case .Phone6: return CGSize(width: 375, height: 667)
        case .Phone6p: return CGSize(width: 414, height: 736)
        case .Pad: return CGSize(width: 768, height: 1024)
        }
    }
}

public let kScreenSize = UIScreen.mainScreen().bounds.size

public let isPhone = (UIDevice.currentDevice().userInterfaceIdiom == .Phone)
public let isPad = (UIDevice.currentDevice().userInterfaceIdiom == .Pad)

public let isPhone4 = (isPhone && DeviceType.Phone4.size == kScreenSize)
public let isPhone5 = (isPhone && DeviceType.Phone5.size == kScreenSize)
public let isPhone6 = (isPhone && DeviceType.Phone6.size == kScreenSize)
public let isPhone6p = (isPhone && DeviceType.Phone6p.size == kScreenSize)

public func loadNib<T: UIView>(aClass: T.Type) -> T! {
    return NSBundle.mainBundle().loadNibNamed(String(T), owner: nil, options: nil).first as? T
}
