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

}
