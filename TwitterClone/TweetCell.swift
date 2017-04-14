//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Brandon Aubrey on 4/11/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var favorite: Bool = false
    var retweet: Bool = false
    
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet?.name
            tweetTextLabel.text = tweet?.text
            
            if let url = tweet?.profileImageUrl {
                profileImage.setImageWith(URL(string: url)!)
            }
            if let stamp = tweet?.timestamp {
                let formatter = DateFormatter()
                let hoursSinceTweet = abs(stamp.timeIntervalSinceNow/360)
                if hoursSinceTweet < 24 {
                    timeStamp.text = "\(Int(floor(hoursSinceTweet)))h"
                    
                }else {

                formatter.dateFormat = "MM/d/yy"
                timeStamp.text = formatter.string(from: stamp)
                }
            }
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
    
    @IBAction func replyButton(_ sender: Any) {
        
        
    }
    
    @IBAction func retweetButton(_ sender: Any) {
        
        let img = (retweet) ? UIImage(named: "retweetGreen.png") : UIImage(named: "retweet.png")
        retweetButton.setImage(img, for: UIControlState.normal)
        retweet = !retweet
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        
        let img = (favorite) ? UIImage(named: "favorRed.png") : UIImage(named: "favor.png")
        favoriteButton.setImage(img, for: UIControlState.normal)
        favorite = !favorite
    }
}
