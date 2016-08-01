//
//  NSLock.swift
//  SwiftUtils
//
//  Created by DaoNV on 12/7/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import UIKit

extension NSLock {
    public func sync(@noescape block: () -> Void) {
        let locked = tryLock()
        block()
        if locked {
            unlock()
        }
    }
}
