//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/21/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User? = User.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()

        if user != nil {
            backgroundImage.setImageWith((user?.profileBackgroundUrl)!)
            usernameLabel.text = user?.name
            screennameLabel.text = user?.screename
            tweetCountLabel.text = "\(user?.tweetsCount ?? 0)"
            followingCountLabel.text = "\(user?.followingCount ?? 0)"
            followerCountLabel.text = "\(user?.followersCount ?? 0)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
