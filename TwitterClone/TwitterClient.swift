//
//  TwitterClien.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let baseURL = "https://api.twitter.com"
let consumerKey = "z7ctDbsivGUStJg1fgjPJbepS"
let consumerSecret = "CGAybubWNQDEGf33mwWn9AwtqMb1VxM6ZTvEeaJxMxe2psWBqQ"
let requestTokenURL = "oauth/request_token"
let authorize = "/oauth/authorize?oauth_token="

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")! as URL!,
                                                        consumerKey: consumerKey,
                                                        consumerSecret: consumerSecret)

    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        
        
        get("1.1/statuses/home_timeline.json",
            parameters: nil,
            progress: nil,
            success: { (task: URLSessionDataTask?, response: Any?) -> Void in
                let dictionaries = response as! [NSDictionary]
                
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                
                
                success(tweets)
//                for tweet in tweets {
//                    print("\(tweet.text)")
//                }
        
        
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            failure(error)

        })
    
    }

    func currentAccount() {
        
        get("1.1/account/verify_credentials.json",
                    parameters: nil,
                    progress: nil,
                    success: { (task: URLSessionDataTask?, response: Any?) -> Void in
                        let userDictionary = response as! NSDictionary
                        let user = User(dictionary: userDictionary)
                        
                        
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            
        })
    }
}
