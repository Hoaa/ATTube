//
//  UIView.swift
//  ATTube
//
//  Created by Asiantech1 on 8/4/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    var originX: CGFloat {
        set { frame = CGRect(x: newValue, y: originY, width: width, height: height) }
        get { return frame.origin.x }
    }

    var originY: CGFloat {
        set { frame = CGRect(x: originX, y: newValue, width: width, height: height) }
        get { return frame.origin.y }
    }

    var width: CGFloat {
        set { frame = CGRect(x: originX, y: originY, width: newValue, height: height) }
        get { return bounds.width }
    }

    var height: CGFloat {
        set { frame = CGRect(x: originX, y: originY, width: width, height: newValue) }
        get { return bounds.height }
    }

    convenience init(originX: CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(x: originX, y: originY, width: width, height: height))
    }

    convenience init(origin: CGPoint, size: CGSize) {
        self.init(frame: CGRect(origin: origin, size: size))
    }
}
