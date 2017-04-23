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
    
    @IBOutlet weak var tableView: UITableView!
    
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = 236

    var pageControl: UIPageControl! = UIPageControl(frame: CGRect(x: 0, y: 204, width: 38, height: 136))
    var scrollView: UIScrollView! = UIScrollView(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 236))
    
    let blurEffectView: UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.dark))
    
    var user: User? = User.currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()

        if user != nil {
            backgroundImage.setImageWith((user?.profileBackgroundUrl)!)
            usernameLabel.text = user?.name
            screennameLabel.text = user?.screename
            tweetCountLabel.text = "\(user?.tweetsCount ?? 0)"
            followingCountLabel.text = "\(user?.followingCount ?? 0)"
            followerCountLabel.text = "\(user?.followersCount ?? 0)"
        }
    }
    
    @IBAction func onMenuButton(_ sender: Any) {
        HamburgerViewController.sharedInstance.moveMenu()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func setupScrollView() {
        // Actual scroll view
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: width * 2, height: height)
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        // Page control
        pageControl.center.x = view.center.x
        pageControl.numberOfPages = 2
        view.addSubview(pageControl)
        
        // Page 1
        if let profilePictureURL = user?.profileUrl {
            let profileImageView = UIImageView(frame: CGRect(x: 0, y: 100, width: 60, height: 60))
            profileImageView.setImageWith(profilePictureURL)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            profileImageView.center.x = view.center.x
            scrollView.addSubview(profileImageView)
        }
        
        if let name = user?.name {
            let nameLabel = UILabel(frame: CGRect(x: 0, y: 176, width: width - 16, height: 16))
            let nameAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 15.0)
            ]
            let attributedText = NSAttributedString(string: "\(name)", attributes: nameAttributes)
            nameLabel.attributedText = attributedText
            nameLabel.numberOfLines = 0
            nameLabel.lineBreakMode = .byWordWrapping
            nameLabel.sizeToFit()
            nameLabel.center.x = view.center.x
            scrollView.addSubview(nameLabel)
        }
        
        if let sn = user?.screename {
            let screennameLabel = UILabel(frame: CGRect(x: 0, y: 196, width: width - 16, height: 16))
            let screennameAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 13.0)
            ]
            let attributedText = NSAttributedString(string: "@\(sn)", attributes: screennameAttributes)
            screennameLabel.attributedText = attributedText
            screennameLabel.numberOfLines = 0
            screennameLabel.lineBreakMode = .byWordWrapping
            screennameLabel.sizeToFit()
            screennameLabel.center.x = view.center.x
            scrollView.addSubview(screennameLabel)
        }
        
        // Page 2
        let locationLabel = UILabel(frame: CGRect(x: width + 8, y: 140, width: width - 16, height: 16))
        if let location = user?.location {
            let locationAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
            ]
            let attributedText = NSAttributedString(string: "\(location)", attributes: locationAttributes)
            locationLabel.attributedText = attributedText
            locationLabel.numberOfLines = 0
            locationLabel.lineBreakMode = .byWordWrapping
            locationLabel.sizeToFit()
            locationLabel.center.x = width / 2 + width
            locationLabel.center.y = height / 2
            scrollView.addSubview(locationLabel)
        }
        
        if let tagline = user?.tagline {
            let taglineLabel = UILabel(frame: CGRect(x: width, y: locationLabel.frame.origin.y - 20, width: width - 16, height: 16))
            let taglineAttributes = [
                NSForegroundColorAttributeName: UIColor.white,
                NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)
            ]
            let attributedText = NSAttributedString(string: "\(tagline)", attributes: taglineAttributes)
            taglineLabel.attributedText = attributedText
            taglineLabel.numberOfLines = 0
            taglineLabel.lineBreakMode = .byWordWrapping
            taglineLabel.sizeToFit()
            taglineLabel.center.x = view.center.x + width
            scrollView.addSubview(taglineLabel)
        }
    }


}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = self.scrollView.panGestureRecognizer.velocity(in: self.scrollView.superview).x
        let duration: TimeInterval = Double(width / velocity)
        
        if self.scrollView.panGestureRecognizer.translation(in: self.scrollView.superview).x > 0 {
            UIView.animate(withDuration: duration, animations: {
                self.backgroundImage.alpha = 1
            })
            
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.backgroundImage.alpha = 0.4
            })
        }
        
        if tableView.contentOffset.y < 0 {
            backgroundImage.frame.size.height = height - self.tableView.contentOffset.y
            UIView.animate(withDuration: 0.5, animations: {
                self.blurEffectView.alpha = 1
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page : Int = Int(round(scrollView.contentOffset.x / width))
        pageControl.currentPage = page
        
        backgroundImage.frame.size = CGSize(width: width, height: height)
        UIView.animate(withDuration: 0.3, animations: {
            self.blurEffectView.alpha = 0 })
    }
}
