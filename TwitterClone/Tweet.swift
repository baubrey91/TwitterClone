//
//  Tweet.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
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
        
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        let user = dictionary["user"] as! NSDictionary
        name = user["name"] as? String
        screenName = user["screen_name"] as? String
        profileImageUrl = user["profile_image_url"] as? String
        
        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString{
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
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }

}
/*{
    contributors = "<null>";
    coordinates = "<null>";
    "created_at" = "Wed Apr 12 02:26:25 +0000 2017";
    entities =     {
        hashtags =         (
        );
        symbols =         (
        );
        urls =         (
        );
        "user_mentions" =         (
        );
    };
    "favorite_count" = 43;
    favorited = 0;
    geo = "<null>";
    id = 851984823950483456;
    "id_str" = 851984823950483456;
    "in_reply_to_screen_name" = Phillies;
    "in_reply_to_status_id" = 851983887571931143;
    "in_reply_to_status_id_str" = 851983887571931143;
    "in_reply_to_user_id" = 53178109;
    "in_reply_to_user_id_str" = 53178109;
    "is_quote_status" = 0;
    lang = en;
    place = "<null>";
    "retweet_count" = 13;
    retweeted = 0;
    source = "<a href=\"http://twitter.com/download/iphone\" rel=\"nofollow\">Twitter for iPhone</a>";
    text = "And Maikel Franco brings Nava home to make it 13-4.";
    truncated = 0;
    user =     {
        "contributors_enabled" = 0;
        "created_at" = "Thu Jul 02 20:30:53 +0000 2009";
        "default_profile" = 0;
        "default_profile_image" = 0;
        description = "Official Twitter of the Philadelphia Phillies";
        entities =         {
            description =             {
                urls =                 (
                );
            };
            url =             {
                urls =                 (
                    {
                        "display_url" = "phillies.com";
                        "expanded_url" = "http://phillies.com";
                        indices =                         (
                            0,
                            23
                        );
                        url = "https://t.co/d0QjMpr3dI";
                    }
                );
            };
        };
        "favourites_count" = 10003;
        "follow_request_sent" = 0;
        "followers_count" = 1572549;
        following = 1;
        "friends_count" = 352;
        "geo_enabled" = 1;
        "has_extended_profile" = 0;
        id = 53178109;
        "id_str" = 53178109;
        "is_translation_enabled" = 0;
        "is_translator" = 0;
        lang = en;
        "listed_count" = 6354;
        location = "Citizens Bank Park";
        name = Phillies;
        notifications = 0;
        "profile_background_color" = E61515;
        "profile_background_image_url" = "http://pbs.twimg.com/profile_background_images/378800000026241909/3d266c693a29a808aebe3e097e344f5a.jpeg";
        "profile_background_image_url_https" = "https://pbs.twimg.com/profile_background_images/378800000026241909/3d266c693a29a808aebe3e097e344f5a.jpeg";
        "profile_background_tile" = 0;
        "profile_banner_url" = "https://pbs.twimg.com/profile_banners/53178109/1467394701";
        "profile_image_url" = "http://pbs.twimg.com/profile_images/789442175679463425/aVi94sUc_normal.jpg";
        "profile_image_url_https" = "https://pbs.twimg.com/profile_images/789442175679463425/aVi94sUc_normal.jpg";
        "profile_link_color" = 2200FF;
        "profile_sidebar_border_color" = FFFFFF;
        "profile_sidebar_fill_color" = FFFFFF;
        "profile_text_color" = EB092B;
        "profile_use_background_image" = 1;
        protected = 0;
        "screen_name" = Phillies;
        "statuses_count" = 25995;
        "time_zone" = "Eastern Time (US & Canada)";
        "translator_type" = none;
        url = "https://t.co/d0QjMpr3dI";
        "utc_offset" = "-14400";
        verified = 1;
    };
}]
*/
