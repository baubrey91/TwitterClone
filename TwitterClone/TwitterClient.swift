//
//  TwitterClien.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseUrl = "https://api.twitter.com"
let consumerKey = "z7ctDbsivGUStJg1fgjPJbepS"
let consumerSecret = "CGAybubWNQDEGf33mwWn9AwtqMb1VxM6ZTvEeaJxMxe2psWBqQ"
let requestTokenURL = "oauth/request_token"
let authorize = "/oauth/authorize?oauth_token="

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")! as URL!,
                                                        consumerKey: consumerKey,
                                                        consumerSecret: consumerSecret)
    
    var maxId: Int?
    var minId: Int?
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: requestTokenURL,
                                  method: "GET",
                                  callbackURL: URL(string: "twitterclone://oauth"),
                                  scope: nil,
                                  success: { (requestToken: BDBOAuth1Credential?) -> Void in
                                    let url = URL(string: "\(baseUrl + authorize + requestToken!.token!)")!
                                    UIApplication.shared.open(url)
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        }
    }
    
    
    func logout() {
        
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    
    }
    func handleOpenUrl(url: URL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token",
                                 method: "POST",
                                 requestToken: requestToken,
                                 success: { (accessToken: BDBOAuth1Credential?) -> Void in
                                    print("I got the access token!")
                                    
                                    self.currentAccount(sucess: { (user: User) -> () in
                                        User.currentUser = user
                                        self.loginSuccess?()
                                    }, failure: {(error: Error) -> () in
                                        self.loginFailure?(error)
                                        })
                                    
                                }) { (error: Error?) -> Void in
                                        print("error: \(error?.localizedDescription)")
                                    self.loginFailure?(error!)

        }
        
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        var parameters = ["count": 20]

        get("1.1/statuses/home_timeline.json",
            parameters: parameters,
            progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                
                print(dictionaries)
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                let tweetIDs = tweets.reduce([]) { (result, tweet) -> [Int] in
                    if let idString = tweet.id, let id = Int(idString) {
                        return result + [id]
                    } else {
                        return result
                    }
                }
                
                
                self.maxId = tweetIDs.sorted().last
                self.minId = tweetIDs.sorted().first
                
                success(tweets)
        
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
    
    }

    func currentAccount(sucess: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                sucess(user)
                
                
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
    }
    
//    func postTweet(tweetBody: String, replyToStatusID: String?, completion: @escaping (Tweet?, Error?) -> ()) {
//        
//        var params = ["status" : tweetBody]
//        
//        if let replyId = replyToStatusID {
//            params["in_reply_to_status_id"] = replyId
//        }
//        
//        sessionManager.request(updateStatusURL, method: .post, parameters: params, encoding: URLEncoding.queryString)
//            .responseObject { (response: DataResponse<Tweet>) in
//                switch response.result {
//                case .success(let value):
//                    let tweet = value
//                    completion(tweet, nil)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    completion(nil, error)
//                }
//                
//        }
//        
//    }
    
    
    func favorite(create: Bool,
                  tweet: Tweet,
                  success: @escaping (Void) -> Void,
                  failure: @escaping (Error) -> Void) {
        
        let url = (create) ? "1.1/favorites/create.json" : "1.1/favorites/destroy.json"

        if let id = tweet.id {
            post(url,
                parameters: ["id": id],
                progress: nil,
                success: { _ in success() },
                failure: { (_, error: Error) in
                    failure(error)
            })
        }
    }
    
    func reweet(id: String,
                retweet: Bool,
                success: @escaping (Bool) -> (Void),
                failure: @escaping (Error) -> Void) {
        
        let url = (retweet) ?  "1.1/statuses/unretweet/\(id).json" : "1.1/statuses/retweet/\(id).json"
        let params = ["id" : id]
        post(url,
             parameters:params,
             progress:nil,
             success: { (task: URLSessionDataTask?, response: Any?) -> Void in
                if let dictionary = response as? NSDictionary {
                    //let tweet = Tweet(dictionary: dictionary)
                    success(true)
                } },
             failure: { (_, error: Error) in
                failure(error)
        })
    }
    
            
//            //un retweet
//            print(tweetID)
//            sessionManager.request(statusURL + tweetID + ".json?include_my_retweet=1", method: .get)
//                .responseObject { (response: DataResponse<Tweet>) in
//                    switch response.result {
//                    case .success(let value):
//                        let tweet = value
//                        
//                        let retweetID = tweet.currentUserRetweet!.id_str
//                        
//                        self.sessionManager.request(self.unRetweetURL + retweetID! + ".json", method: .post)
//                            .responseObject { (response: DataResponse<Tweet>) in
//                                switch response.result {
//                                case .success(let value):
//                                    let tweet = value
//                                    completion(tweet, nil)
//                                case .failure(let error):
//                                    print(error.localizedDescription)
//                                    completion(nil, error)
//                                }
//                        }
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        completion(nil, error)
//                    }
//            }
//        }else{
//            sessionManager.request(retweetURL + tweetID + ".json", method: .post)
//                .responseObject { (response: DataResponse<Tweet>) in
//                    switch response.result {
//                    case .success(let value):
//                        let tweet = value
//                        completion(tweet, nil)
//                    case .failure(let error):
//                        print(error.localizedDescription)
//                        completion(nil, error)
//                    }
//    
//        }
//    }

    
//    if retweeted {
//    let URL = String("1.1/statuses/unretweet/\(id).json")
//    POST(URL, parameters: ["id": id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//    success(false)
//    }) { (task: NSURLSessionDataTask?, error: NSError) in
//    failure(error)
//    }
//    } else {
//    let URL = String("1.1/statuses/retweet/\(id).json")
//    POST(URL, parameters: ["id": id], progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
//    success(true)
//    }) { (task: NSURLSessionDataTask?, error: NSError) in
//    failure(error)
//    }
//    }

    
    
    func postTweet(tweet: String,
                   replyToStatusID: String?,
                   success: @escaping (Tweet) -> (Void),
                   failure: @escaping (Error) -> Void) {
        
        var parameters = ["status" : tweet]
        
//        if let replyId = replyToStatusID {
//            parameters["in_reply_to_status_id"] = replyId
//        }
        
        post("1.1/statuses/update.json",
             parameters: parameters,
             progress: nil,
             success: { (task: URLSessionDataTask?, response: Any?) -> Void in
                if let dictionary = response as? NSDictionary {
                    let tweet = Tweet(dictionary: dictionary)
                    success(tweet)
                } },
             failure: { (_, error: Error) in
                failure(error)
        })
    }
}
