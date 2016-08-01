//
//  UIViewController.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

extension UIViewController {
    public class func vc() -> Self {
        return self.init(nibName: String(self), bundle: nil)
    }
}
