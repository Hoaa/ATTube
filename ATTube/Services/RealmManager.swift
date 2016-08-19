//
//  RealmManager.swift
//  ATTube
//
//  Created by Quang Phù on 8/18/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import RealmSwift

typealias RealmComplete = () -> Void

class RealmManager {
    static let realm = try? Realm()

    class func getAllPlaylist() -> Results<Playlist>? {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let playlistNames = realm?.objects(Playlist)
        return playlistNames
    }

    class func getAvailablePlaylists() -> Results<Playlist>? {
        let playlistNames = realm?.objects(Playlist).filter("videos.@count > 0")
        return playlistNames
    }

    class func addPlaylist(name: String, finished: RealmComplete) {

        if let playlists = realm?.objects(Playlist) {
            for item in playlists {
                if item.title == name {
                    return
                }
            }
        }

        do {
            let playlist = Playlist(name: name)
            try realm?.write({
                realm?.add(playlist)
            })
            finished()
        } catch { }
    }

    class func addVideo(video: Video, Into listVideos: List<Video>) -> Bool {
        var temporary = video
        let filterVideo = realm?.objects(Video).filter("id = %@", temporary.id!).first
        if let filterVideo = filterVideo {
            temporary = filterVideo
        }
        do {
            try realm?.write({
                listVideos.append(temporary)
            })
            return true
        } catch { }
        return false
    }
}
