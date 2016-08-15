//
//  APIManager.swift
//  ATTube
//
//  Created by Asiantech1 on 8/9/16.
//  Copyright © 2016 at. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

typealias APIComplete = (videos: [Video]?, nextPageToken: String?, error: NSError?) -> Void
typealias APISuggestVideosNameComplete = (videosName: [String], error: NSError?) -> Void

enum Router: URLRequestConvertible {
    static var OAuthToken: String?

    case Trending(maxResults: Int, regionCode: String, nextPageToken: String?)

    private var method: Alamofire.Method {
        switch self {
        case .Trending:
            return .GET
        }
    }

    private var path: String {
        switch self {
        case .Trending:
            return "/videos"
        }
    }

    private var parameter: [String: AnyObject] {
        var parameters = [String: AnyObject]()
        parameters["key"] = Strings.key

        switch self {
        case .Trending(let maxResults, let regionCode, let nextPageToken):
            parameters["part"] = Strings.trendingPart
            parameters["chart"] = Strings.trendingChart
            parameters["maxResults"] = maxResults
            parameters["regionCode"] = regionCode
            if let nextPageToken = nextPageToken {
                parameters["pageToken"] = nextPageToken
            }
            return parameters
        }
    }

    // MARK: URLRequestConvertible
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Strings.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue

        if let token = Router.OAuthToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        switch self {
        case .Trending:
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameter).0
        }
    }
}

class APIManager {

    private var searchRequest: Alamofire.Request?

    class var sharedInstance: APIManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: APIManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = APIManager()
        }
        return Static.instance!
    }

    func getTrendingVideos(maxResults: Int, regionCode: String, nextPageToken: String?, completionHanlder: APIComplete) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do your task
            Alamofire.request(Router.Trending(maxResults: maxResults, regionCode: regionCode, nextPageToken: nextPageToken))
                .responseJSON(completionHandler: { (response) in
                    self.executeResponse(response, completionHanlder: completionHanlder)
            })
        }
    }

    private func executeResponse(response: Response<AnyObject, NSError>, completionHanlder: APIComplete) {
        switch response.result {
        case .Success:
            var videos: [Video] = []
            if let JSON = response.result.value as? NSDictionary {
                let nextPageToken = JSON["nextPageToken"] as? String
                print("API: \(nextPageToken)")
                if let items = JSON["items"] as? NSArray {
                    for item in items {
                        if let video = Mapper<Video>().map(item) {
                            videos.append(video)
                        }
                    }
                    completionHanlder(videos: videos, nextPageToken: nextPageToken, error: nil)
                }
            }
        case .Failure(let error):
            completionHanlder(videos: nil, nextPageToken: nil, error: error)
        }
    }
}
