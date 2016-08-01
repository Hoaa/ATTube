//
//  Dictionary.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import Foundation

extension Dictionary {
    public var allKeys: [Key] {
        return Array(keys)
    }

    public var allValues: [Value] {
        return Array(values)
    }

    public mutating func updateValues(dic: [Key: Value]?) {
        if let dic = dic {
            for (key, value) in dic {
                self[key] = value
            }
        }
    }

    public func map<U, V>(@noescape trans: Element -> (U, V)?) -> [U: V] {
        var mapped = [U: V]()
        for (u, v) in self {
            if let (u, v) = trans((u, v)) {
                mapped[u] = v
            }
        }
        return mapped
    }

    public func has(key: Key) -> Bool {
        return indexForKey(key) != nil
    }

    public mutating func shift() -> (Key, Value?)? {
        if let key = keys.first {
            return (key, removeValueForKey(key))
        }
        return nil
    }

    public var data: NSData? {
        do {
            guard let json = self as? AnyObject else { return nil }
            return try NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            return nil
        }
    }
}
