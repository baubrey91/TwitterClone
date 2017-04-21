//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/21/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
//    var userName: String?
//    var screenName: String?
//    var tweetCount: Int?
//    var followingCount: Int?
//    var followersCount: Int?
//    var backgroundImage: URL?
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    
    var user: User? {
        didSet {
            //backgroundImage.setImageWith((user?.profileBackgroundUrl)!)
            tweetCountLabel.text = "\(user?.tweetsCount)"
            followingCountLabel.text = "\(user?.followingCount)"
            followerCountLabel.text = "\(user?.followersCount)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
