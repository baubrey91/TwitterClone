//
//  MenuViewController.swift
//  HamburgerMenu
//
//  Created by Brandon on 4/17/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var timeLineNavController: UIViewController!
    private var mentionsNavController: UINavigationController!
    private var profileNavController: UINavigationController!

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenName: UILabel!
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    let titles = ["TimeLine","Profile","Mentions", "Logout"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let timeLineStoryboard = UIStoryboard(name: "Timeline", bundle: nil)
        let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
        timeLineNavController = timeLineStoryboard.instantiateViewController(withIdentifier: "TweetNavigationController")
        profileNavController = profileStoryboard.instantiateViewController(withIdentifier: "ProfileNavController") as! UINavigationController
        let profileViewController = profileNavController.topViewController as! ProfileViewController
        profileViewController.user = User.currentUser
        mentionsNavController = timeLineStoryboard.instantiateViewController(withIdentifier: "TweetNavigationController") as! UINavigationController
        let mentionsViewController = mentionsNavController.topViewController as! TweetsViewController
        mentionsViewController.mentionsMode = true

        
        viewControllers.append(timeLineNavController)
        viewControllers.append(profileNavController)
        viewControllers.append(mentionsNavController)
        //viewControllers.append(profileViewController)
        
        hamburgerViewController.contentViewController = timeLineNavController
        
        //Set up profile information
        
        userName.text = User.currentUser?.name
        screenName.text = User.currentUser?.screename
        if let url = User.currentUser?.profileUrl {
            profileImage.setImageWith(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 3 {
            TwitterClient.sharedInstance?.logout()
        } else {
            
        tableView.deselectRow(at: indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
}
