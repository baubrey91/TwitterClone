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
            parameters: nil,
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
}
