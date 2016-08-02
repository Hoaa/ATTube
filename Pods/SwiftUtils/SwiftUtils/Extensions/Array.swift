//
//  Array.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

extension Array {
    public mutating func shuffle() {
        for i in (1 ..< count).reverse() {
            let j = Int.random(max: i - 1)
            swap(&self[i], &self[j])
        }
    }

    public var shuffled: [Element] {
        var array = self
        array.shuffle()
        return array
    }

    public func map<T>(@noescape trans: Element -> T?) -> [T] {
        var mapped = [T]()
        for e in self {
            if let e = trans(e) {
                mapped.append(e)
            }
        }
        return mapped
    }
}

extension Array where Element: Equatable {
    public mutating func remove(ele: Element) -> Bool {
        if let i = indexOf(ele) {
            removeAtIndex(i)
            return true
        }
        return false
    }
}
