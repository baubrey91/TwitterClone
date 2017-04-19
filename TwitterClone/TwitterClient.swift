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

    //singleton shared instance
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")! as URL!,
                                                        consumerKey: consumerKey,
                                                        consumerSecret: consumerSecret)

    var maxId: Int?
    var minId: Int?
    var count = 20

    var loginSuccess: (() -> Void)?
    var loginFailure: ((Error) -> Void)?

    //login function
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {

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

    //logout function
    func logout() {

        User.currentUser = nil
        deauthorize()

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification),
                                        object: nil)

    }
    
    
    func handleOpenUrl(url: URL) {

        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessToken(withPath: "oauth/access_token",
                                 method: "POST",
                                 requestToken: requestToken,
                                 success: { (_: BDBOAuth1Credential?) -> Void in
                                    print("I got the access token!")
                                    
                                    self.currentAccount(sucess: { (user: User) -> Void in
                                        User.currentUser = user
                                        self.loginSuccess?()
                                    }, failure: {(error: Error) -> Void in
                                        self.loginFailure?(error)
                                        })

                                }) { (error: Error?) -> Void in
                                        print("error: \(error?.localizedDescription)")
                                    self.loginFailure?(error!)
        }
    }
    
    //load tweets for home
    func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {

        let parameters = ["count": count]
        
        count += 20

        get("1.1/statuses/home_timeline.json",
            parameters: parameters,
            progress: nil,
            success: { (_: URLSessionDataTask?, response: Any?) -> Void in
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
        
        }, failure: { (_: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
    
    }
    
    func mentionsTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        get("1.1/statuses/mentions_timeline.json", parameters: nil,
            progress: { (Progress) -> Void in
                // Do nothing
        },
            success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
                
        }, failure: { (task: URLSessionTask?, error: Error) -> Void in
            failure(error)
        }
        )
    }

    //get current account
    func currentAccount(sucess: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        
        get("1.1/account/verify_credentials.json",
            parameters: nil,
            progress: nil,
            success: { (_: URLSessionDataTask?, response: Any?) -> Void in
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                
                sucess(user)
                
        }, failure: { (_: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)
        })
    }
    
    //favorite another persons tweet
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
    
    //retweet someone elses tweet
    func reweet(id: String,
                retweet: Bool,
                success: @escaping (Bool) -> (Void),
                failure: @escaping (Error) -> Void) {
        
        let url = (retweet) ?  "1.1/statuses/unretweet/\(id).json" : "1.1/statuses/retweet/\(id).json"
        let params = ["id": id]
        post(url,
             parameters:params,
             progress:nil,
             success: { (_: URLSessionDataTask?, _: Any?) -> Void in
                
                    success(true)
                 },
             failure: { (_, error: Error) in
                failure(error)
        })
    }

    //compose a tweet
    func postTweet(tweet: String,
                   replyToStatusID: String?,
                   success: @escaping (Tweet) -> (Void),
                   failure: @escaping (Error) -> Void) {
        
        let parameters = ["status": tweet]
        
//        if let replyId = replyToStatusID {
//            parameters["in_reply_to_status_id"] = replyId
//        }
        
        post("1.1/statuses/update.json",
             parameters: parameters,
             progress: nil,
             success: { (_: URLSessionDataTask?, response: Any?) -> Void in
                if let dictionary = response as? NSDictionary {
                    let tweet = Tweet(dictionary: dictionary)
                    success(tweet)
                } },
             failure: { (_, error: Error) in
                failure(error)
        })
    }
}
