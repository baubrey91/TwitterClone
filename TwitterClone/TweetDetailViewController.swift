//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/14/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit


class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    var tweet : Tweet?
    
    var retweetBool = true
    var favoriteBool = true
    
    override func viewDidLoad() {
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        usernameLabel.text = tweet?.name
        screennameLabel.text = tweet?.screenName
        tweetTextLabel.text = tweet?.text
        //retweetLabel.text = tweet?.
        if let url = tweet?.profileImageUrl {
            profileImage.setImageWith(URL(string: url)!)
        }
        //timestampLabel.text = tweet?.timestamp
        retweetsLabel.text = String(describing: tweet?.retweetCount ?? 0)
        favoritesLabel.text = String(describing: tweet?.favoriteCount ?? 0)
    }
    
    
    @IBAction func retweetButton(_ sender: Any) {
        TwitterClient.sharedInstance?.reweet(id: (tweet?.id)!,
                                             retweet: retweetBool,
                                             success: {(_) in
                                                self.retweetBool = !self.retweetBool
        },
                                             failure: {(error) in
                                                print(error.localizedDescription)
        })
        
    }
    

    @IBAction func favoriteButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.favorite(create: favoriteBool,
                                               tweet: tweet!,
                                               success: {(_) in
                                                //configure favorite button
                                                self.favoriteBool = !self.favoriteBool
        },
                                               failure: {(error) in
                                                print(error.localizedDescription)
        }
    )}
}
