//
//  GCD.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/7/15.
//  Copyright © 2015 Apple Inc. All rights reserved.
//

import Foundation

public func dp_main(wait: Bool = true, block: dispatch_block_t?) {
    guard let block = block else { return }
    if wait {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_sync(dispatch_get_main_queue(), block)
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}

public func dp_background(wait: Bool = false, block: dispatch_block_t?) {
    guard let block = block else { return }
    if wait {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }
}

public func dp_after(seconds: Double, block: dispatch_block_t?) {
    guard let block = block else { return }
    let nsec = Int64(seconds * Double(NSEC_PER_SEC))
    let time = dispatch_time(DISPATCH_TIME_NOW, nsec)
    dispatch_after(time, dispatch_get_main_queue(), block)
}

public func wait(@noescape block: () -> Bool) {
    while !block() && NSRunLoop.currentRunLoop().runMode(NSRunLoopCommonModes, beforeDate: NSDate.distantFuture()) { }
}

public func wait(sec: NSTimeInterval) {
    var done = false
    dp_after(sec) { () -> Void in
        done = true
    }
    while !done && NSRunLoop.currentRunLoop().runMode(NSRunLoopCommonModes, beforeDate: NSDate.distantFuture()) { }
}
