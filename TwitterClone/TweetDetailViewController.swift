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
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet : Tweet?
    
    var retweetBool = true
    var favoriteBool = true
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        usernameLabel.text = tweet?.name
        screennameLabel.text = tweet?.screenName
        tweetTextLabel.text = tweet?.text

        retweetBool = !(tweet?.retweeted)!
        favoriteBool = !(tweet?.favorited)!

        if let url = tweet?.profileImageUrl {
            profileImage.setImageWith(URL(string: url)!)
        }
        if let timestamp = tweet?.timestamp {
            timestampLabel.text = timestamp.timeAgo()
        }
        retweetsLabel.text = String(describing: tweet?.retweetCount ?? 0)
        favoritesLabel.text = String(describing: tweet?.favoriteCount ?? 0)
        let favImg = (favoriteBool) ? UIImage(named: "favor.png") : UIImage(named: "favorRed.png")
        let reImg = (retweetBool) ? UIImage(named: "retweet.png") : UIImage(named: "retweetGreen.png")
        self.favoriteButton.setImage(favImg, for: UIControlState.normal)
        self.retweetButton.setImage(reImg, for: UIControlState.normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let composeController = navigationController.topViewController as! ComposeTweetViewController
        composeController.replyingTo = screennameLabel.text
        composeController.replyID = tweet?.id
    }
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func retweetButton(_ sender: Any) {
        
        let img = (retweetBool) ? UIImage(named: "retweetGreen.png") : UIImage(named: "retweet.png")

        TwitterClient.sharedInstance?.reweet(id: (tweet?.id)!,
                                             retweet: retweetBool,
                                             success: {(_) in
                                                //configure retweets
                                                let incValue = ((self.retweetBool) ? 1 : 0)
                                                let retweetCount = Int(self.tweet?.retweetCount ?? 0) + incValue
                                                self.retweetsLabel.text = String(describing: retweetCount)
                                                self.retweetButton.setImage(img, for: UIControlState.normal)
                                                self.retweetBool = !self.retweetBool
        },
                                             failure: {(error) in
                                                Helpers.Alert(errorMessage: error.localizedDescription, vc: self)

        })
        
    }
    

    @IBAction func favoriteButton(_ sender: Any) {
        
        let img = (favoriteBool) ? UIImage(named: "favorRed.png") : UIImage(named: "favor.png")

        TwitterClient.sharedInstance?.favorite(create: favoriteBool,
                                               tweet: tweet!,
                                               success: {(_) in
                                                //configure favorite button
                                                let incValue = ((self.favoriteBool) ? 1 : 0)
                                                let favsCount = Int(self.tweet?.favoriteCount ?? 0) + incValue
                                                self.favoritesLabel.text = String(describing: favsCount)
                                                self.favoriteButton.setImage(img, for: UIControlState.normal)
                                                self.favoriteBool = !self.favoriteBool
        },
                                               failure: {(error) in
                                                Helpers.Alert(errorMessage: error.localizedDescription, vc: self)
        }
    )}
}
