//
//  NSFileManager.swift
//  SwiftUtils
//
//  Created by DaoNV on 10/23/15.
//  Copyright © 2015 Astraler Technology. All rights reserved.
//

import Foundation

extension NSFileManager {
    public class var homeDir: String! {
        return NSHomeDirectory()
    }

    public class var homeUrl: NSURL! {
        return NSURL(fileURLWithPath: homeDir, isDirectory: true)
    }

    public class var docDir: String! {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
    }

    public class var docUrl: NSURL! {
        return NSURL(fileURLWithPath: docDir, isDirectory: true)
    }

    public class var libraryDir: String! {
        return NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true).first
    }

    public class var libraryUrl: NSURL! {
        return NSURL(fileURLWithPath: libraryDir, isDirectory: true)
    }

    public class var appSupportDir: String! {
        return NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true).first
    }

    public class var appSupportUrl: NSURL! {
        return NSURL(fileURLWithPath: appSupportDir, isDirectory: true)
    }

    public class var tmpDir: String {
        return NSTemporaryDirectory()
    }

    public class var tmpUrl: NSURL {
        return NSURL(fileURLWithPath: tmpDir, isDirectory: true)
    }

    public class func skipBackup(path: String) -> Bool {
        let fm = defaultManager()
        var isDir: ObjCBool = true
        if fm.fileExistsAtPath(path, isDirectory: &isDir) {
            if isDir {
                var success = true
                do {
                    let urls = try fm.contentsOfDirectoryAtPath(path)
                    for url in urls {
                        success = success && skipBackup(url)
                    }
                    return success
                } catch { }
            } else {
                do {
                    let url = NSURL(fileURLWithPath: path)
                    try url.setResourceValue(true, forKey: NSURLIsExcludedFromBackupKey)
                    return true
                } catch { }
            }
        }
        return false
    }

    public class func skipBackup() {
        skipBackup(docDir)
        skipBackup(libraryDir)
    }
}
