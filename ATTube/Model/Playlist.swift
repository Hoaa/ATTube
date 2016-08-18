//
//  Playlist.swift
//  ATTube
//
//  Created by Quang Phù on 8/18/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import RealmSwift

class Playlist: Object {

    dynamic var title = ""
    let videos = List<Video>()

    required convenience init(name: String) {
        self.init()
        self.title = name
    }

    func addVideo(video: Video) -> Bool {
        for item in videos {
            if video.id == item.id {
                return false
            }
        }
        return RealmManager.addVideo(video, Into: videos)
    }
}
