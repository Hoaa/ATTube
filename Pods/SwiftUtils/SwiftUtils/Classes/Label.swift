//
//  Label.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/5/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

public class Label: UILabel {
    public var edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    override public func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var rect = edgeInsets.inset(bounds)
        rect = super.textRectForBounds(rect, limitedToNumberOfLines: numberOfLines)
        return edgeInsets.inverse.inset(rect)
    }

    override public func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(edgeInsets.inset(rect))
    }

    public override func intrinsicContentSize() -> CGSize {
        var size = super.intrinsicContentSize()
        size.width += (edgeInsets.left + edgeInsets.right)
        size.height += (edgeInsets.top + edgeInsets.bottom)
        return size
    }
}
