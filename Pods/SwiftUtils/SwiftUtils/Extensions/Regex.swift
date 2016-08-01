//
//  Regex.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/9/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    public class func regex(pattern: String, ignoreCase: Bool = false) -> NSRegularExpression? {
        let options: NSRegularExpressionOptions = ignoreCase ? [.CaseInsensitive]: []
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            regex = nil
        }
        return regex
    }
}
