//
//  SequenceType.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/8/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import Foundation

extension SequenceType {

    typealias Element = Self.Generator.Element

    public func contains<T: Equatable> (item: T) -> Bool {
        var generator = self.generate()
        while let next = generator.next() {
            if let obj = next as? T where obj == item {
                return true
            }
        }
        return false
    }
}
