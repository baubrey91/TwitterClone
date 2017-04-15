//
//  TweetDetailViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/14/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit


class TweetDetailViewController: UIViewController {
    
    var tweet : Tweet? {
        didSet {
            
        }
    }
    var favoriteBool = true
    
    override func viewDidLoad() {
        
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
