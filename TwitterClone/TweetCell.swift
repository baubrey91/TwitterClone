//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Brandon Aubrey on 4/11/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import NSDateMinimalTimeAgo

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favorite: Bool = false
    var retweet: Bool = false
    var tweetToRetweet: Tweet?
    
    var tweet: Tweet! {
        didSet {
            if let retweet = tweet.retweetedStatus {
                retweetNameLabel.text = tweet.tweetUser!.screename
                tweet = retweet
            } else {
                retweetNameLabel.text = ""
                //tweet = tweet
            }
            nameLabel.text = tweet?.name
            tweetTextLabel.text = tweet?.text
            screenNameLabel.text = "@" + tweet.screenName!
            //retweetNameLabel.text = tweet.screenName
            
            if let url = tweet?.profileImageUrl {
                profileImage.setImageWith(URL(string: url)!)
            }
            if let stamp = tweet?.timestamp {
                timeStamp.text = stamp.timeAgo()
                
//                let formatter = DateFormatter()
//                let hoursSinceTweet = abs(stamp.timeIntervalSinceNow/360)
//                if hoursSinceTweet < 24 {
//                    timeStamp.text = "\(Int(floor(hoursSinceTweet)))h"
//                    
//                }else {
//
//                formatter.dateFormat = "MM/d/yy"
//                timeStamp.text = formatter.string(from: stamp)
               // }
            }

            
            let retweetImg = (tweet?.retweeted)! ? UIImage(named: "retweetGreen.png") : UIImage(named: "retweet.png")
            retweetButton.setImage(retweetImg, for: UIControlState.normal)
            
            let favImg = ((tweet?.favorited)! ? UIImage(named: "favorRed.png") : UIImage(named: "favor.png"))
            favoriteButton.setImage(favImg, for: UIControlState.normal)


        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
