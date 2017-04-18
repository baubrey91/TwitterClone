//
//  Tweet.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    //tweet variables
    var text: String?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var name: String?
    var profileImageUrl: String?
    var screenName: String?
    var id: String?
    var retweeted: Bool?
    var favorited: Bool?
    var tweetUser: User?
    var retweetedStatus: Tweet?
    var retweetUserSN: String?

    init(dictionary: NSDictionary) {

        //configure all variables for tweet cell
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        let user = dictionary["user"] as! NSDictionary
        name = user["name"] as? String
        screenName = user["screen_name"] as? String
        profileImageUrl = user["profile_image_url"] as? String

        let timestampString = dictionary["created_at"] as? String

        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.date(from: timestampString) as! NSDate
        }

        id = {
            if let retweetStatus = dictionary["retweeted_status"] as? [String: AnyObject], !retweetStatus.isEmpty {
                return retweetStatus["id_str"] as? String
            } else {
                return dictionary["id_str"] as? String
            }
        }()

        self.favorited = dictionary["favorited"] as? Bool
        self.retweeted = dictionary["retweeted"] as? Bool

        self.tweetUser = dictionary["user"] as? User

        self.retweetedStatus = dictionary["retweeted_status"] as? Tweet

    }
    //iterate through dicionary of tweets and append them to an array to send out
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}
