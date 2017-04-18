//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Brandon Aubrey on 4/11/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import AFNetworking
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
                retweetNameLabel.text = tweet.tweetUser!.screename! + "retweeted"
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
                let imageUrl: NSURL = NSURL(string: url)!
                profileImage.layer.cornerRadius = 9.0
                profileImage.layer.masksToBounds = true
                profileImage.fadeInImageRequest(imgURL: imageUrl)
            }
            if let stamp = tweet?.timestamp {
                timeStamp.text = stamp.timeAgo()
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

extension TweetCell: updateHomeDelegate {
    
    //send information back to hometimeline to update
    func updateRetweeted(bool: Bool) {
        tweet?.retweeted = bool
        let retweetImg = (tweet?.retweeted)! ? UIImage(named: "retweetGreen.png") : UIImage(named: "retweet.png")
        retweetButton.setImage(retweetImg, for: UIControlState.normal)
    }
    
    func updateFavorite(bool: Bool) {
        tweet?.favorited = bool
        let favImg = ((tweet?.favorited)! ? UIImage(named: "favorRed.png") : UIImage(named: "favor.png"))
        favoriteButton.setImage(favImg, for: UIControlState.normal)
    }
}

extension UIImageView {
    //function in uiimage to fade in images, didn't feel like making a seperate file for this but it shouldn't be here
    func fadeInImageRequest(imgURL: NSURL) {
        
        let imageRequest = URLRequest(url: imgURL as URL)
        
        self.setImageWith(imageRequest as URLRequest, placeholderImage: nil, success: {( imageRequest, imageResponse, image) -> Void in
            
            if imageResponse != nil {
                self.alpha = 0.0
                
                self.image = image
                UIView.animate(withDuration: 2.0, animations: { () -> Void in
                    self.alpha = 3.0
                })
            } else {
                self.image = image
            }
        }, failure: {(imageRequest, imageResponse, error) -> Void in
            
        })
    }
}
