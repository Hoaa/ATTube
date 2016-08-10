//
//  Video.swift
//  ATTube
//
//  Created by Asiantech1 on 8/10/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import ObjectMapper
import Darwin

class Video: Mappable {
    var id: String?
    var channelID: String?
    var title: String?
    var description: String?
    var defaultThumbnailURL: String?
    var mediumThumbnailURL: String?
    var highThumbnailURL: String?
    var duration: String?
    var viewCount: String?

    required init?(_ map: Map) {
    }

    func mapping(map: Map) {
        self.id <- map["id"]
        self.channelID <- map["channelId"]
        self.title <- map["snippet.title"]
        self.description <- map["snippet.description"]
        self.defaultThumbnailURL <- map["snippet.thumbnails.default.url"]
        self.mediumThumbnailURL <- map["snippet.thumbnails.medium.url"]
        self.highThumbnailURL <- map["snippet.thumbnails.high.url"]
        self.duration <- map["contentDetails.duration"]
        self.viewCount <- map["statistics.viewCount"]
    }
}
