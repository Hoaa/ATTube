//
//  RealmManager.swift
//  ATTube
//
//  Created by Quang Phù on 8/18/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import RealmSwift

typealias RealmComplete = (success: Bool, error: NSError?) -> Void

class RealmManager {
    static let realm = try? Realm()

    class func getAllPlaylist() -> Results<Playlist>? {
        let playlistNames = realm?.objects(Playlist)
        return playlistNames
    }

    class func getAvailablePlaylists() -> Results<Playlist>? {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        let playlistNames = realm?.objects(Playlist).filter("videos.@count > 0")
        return playlistNames
    }

    // MARK:- Playlist
    class func addPlaylist(name: String, finished: RealmComplete?) {
        guard let playlists = realm?.objects(Playlist) else { return }
        for item in playlists {
            if item.title == name {
                return
            }
        }
        do {
            let playlist = Playlist(name: name)
            try realm?.write({
                realm?.add(playlist)
            })
            finished?(success: true, error: nil)
        } catch let error as NSError {
            finished?(success: false, error: error)
        }
    }

    class func addVideo(video video: Video?, into listVideos: List<Video>?, finished: RealmComplete?) {
        guard let video = video else { return }
        var temporary = video
        if let filterVideo = realm?.objects(Video).filter("id = %@", temporary.id!).first {
            temporary = filterVideo
        }

        do {
            try realm?.write({
                listVideos?.append(video)
            })
            finished?(success: true, error: nil)
        } catch let error as NSError {
            finished?(success: false, error: error)
        }
    }

    class func addVideo(video video: Video?, intoPlaylistName playlistName: String, finished: RealmComplete?) {
        guard let video = video else { return }
        var temporary = video
        if let filterVideo = realm?.objects(Video).filter("id = %@", temporary.id!).first {
            temporary = filterVideo
        }

        var newPlaylist: Playlist? = nil
        do {
            if let filterPlaylist = realm?.objects(Playlist).filter("title = %@", playlistName).first {
                newPlaylist = filterPlaylist
            }
            if newPlaylist == nil {
                newPlaylist = Playlist(name: playlistName)
                try realm?.write({
                    realm?.add(newPlaylist!)
                })
            }
            guard let newPlaylist = newPlaylist else { return }
            for item in newPlaylist.videos {
                if item.id == temporary.id {
                    finished?(success: false, error: nil)
                    return
                }
            }
            try realm?.write({
                newPlaylist.videos.append(temporary)
            })
            finished?(success: true, error: nil)
        } catch let error as NSError {
            finished?(success: false, error: error)
        }
    }

    class func deleteVideoByIndex(index: Int, inPlaylist playlist: Playlist?, finished: RealmComplete?) {
        guard let playlist = playlist else { return }
        do {
            try realm?.write({
                if index < playlist.videos.count {
                    playlist.videos.removeAtIndex(index)
                }
            })
            finished?(success: true, error: nil)
        } catch let error as NSError {
            finished?(success: false, error: error)
        }
    }

    class func swapVideo(listVideo: List<Video>, between index1: Int, and index2: Int) -> Bool {
        guard index1 < listVideo.count && index2 < listVideo.count else { return false }
        do {
            try realm?.write({
                listVideo.swap(index1, index2)
            })
            return true
        } catch { }
        return false
    }

    class func deletePlaylist(playlist playlist: Playlist?, finished: RealmComplete?) {
        guard let playlist = playlist else { return }
        do {
            try realm?.write({
                realm?.delete(playlist)
            })
            finished?(success: true, error: nil)
        } catch let error as NSError {
            finished?(success: false, error: error)
        }
    }

    // MARK:- Video
    class func deleteVideo(video: Video, finished: RealmComplete?) {
        do {
            try realm?.write({
                realm?.delete(video)
            })
            finished?(success: true, error: nil)
        } catch let error as NSError {
            finished?(success: false, error: error)
        }
    }
}
