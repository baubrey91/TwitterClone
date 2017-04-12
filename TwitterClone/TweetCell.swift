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
            //timeStamp.text = tweet?.timestamp
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
