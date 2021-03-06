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
    case Search(searchKey: String, maxResults: Int, nextPageToken: String?)
    
    var method: Alamofire.Method {
        switch self {
        case .Trending:
            return .GET
        case .Search:
            return .GET
        }
        
    }
    
    var path: String {
        switch self {
        case .Trending:
            return "/videos"
        case .Search:
            return "/search"
        }
        
    }
    
    var parameter: [String: AnyObject] {
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
        case .Search(let searchKey, let maxResults, let nextPageToken):
            parameters["part"] = Strings.searchPart
            parameters["type"] = Strings.videoType
            parameters["videoDefinition"] = Strings.searchVideoDefinition
            parameters["maxResults"] = maxResults
            parameters["q"] = searchKey
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
        case .Search:
            print(Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameter).0)
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
    
    func getVideosWith(searchKey: String, maxResults: Int, nextPageToken: String?, completionHanlder: APIComplete) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            // do your task
            self.searchRequest?.cancel()
            self.searchRequest = Alamofire.request(Router.Search(searchKey: searchKey, maxResults: maxResults, nextPageToken: nextPageToken))
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
                    dispatch_async(dispatch_get_main_queue()) {
                        completionHanlder(videos: videos, nextPageToken: nextPageToken, error: nil)
                    }
                }
            }
        case .Failure(let error):
            dispatch_async(dispatch_get_main_queue()) {
                completionHanlder(videos: nil, nextPageToken: nil, error: error)
            }
        }
    }
    
    func cancel() {
        searchRequest?.cancel()
    }
}
