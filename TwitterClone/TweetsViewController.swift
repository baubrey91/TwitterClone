//
//  ViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import SVProgressHUD

class TweetsViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var tweets = [Tweet]()
    
    var refreshControl: UIRefreshControl!

    var refreshLoadingView : UIView!
    var refreshColorView : UIView!
    var compass_background : UIImageView!
    var compass_spinner : UIImageView!
    
    var isRefreshIconsOverlap = false
    var isRefreshAnimating = false
    
    var isMoreDataLoading = false
    var loadingMoreView: InfiniteScrollActivityView?
    var offSet = 0
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        //set up infinte scroll
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        //set up pull to refresh
        refreshControl = UIRefreshControl()
        PullToRefresh.setupRefreshControl(vc: self)
        refreshControl?.addTarget(self, action: #selector(TweetsViewController.refresh), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)

        //load top 20 tweets to home
        SVProgressHUD.show()
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            self.tableView.reloadData()
            SVProgressHUD.dismiss()

            
        }, failure: { (error: Error) -> () in
            SVProgressHUD.dismiss()
            Helpers.Alert(errorMessage: error.localizedDescription, vc: self)
        })
    }
    
    func refresh(){
        
//        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
//            
//            self.tweets = tweets
//            self.tableView.reloadData()
//            self.refreshControl!.endRefreshing()
//            
//        }, failure: { (error: Error) -> () in
//            Helpers.Alert(errorMessage: error.localizedDescription, vc: self)
//        })
        
        // I set up a timer instead of getting data to showcase the animation, above code will refresh data
        let delayInSeconds = 3.0;
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.refreshControl!.endRefreshing()
        }
    }
    

    @IBAction func onLogoutButton(_ sender: Any) {
        
            TwitterClient.sharedInstance?.logout()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ComposeSegue"{
            
            let navigationController = segue.destination as! UINavigationController
            let composeTweetViewController = navigationController.topViewController as! ComposeTweetViewController
            composeTweetViewController.delegate = self
            //composeTweetViewController.tweet
            //composeTweetViewController.delegate = self
        }
    }
}

extension TweetsViewController : UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController:UINavigationController = storyboard.instantiateViewController(withIdentifier: "NavController") as! UINavigationController
        let detailsViewController = navigationController.topViewController as! TweetDetailViewController
        detailsViewController.tweet = tweets[indexPath.row]
        navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
        navigationController.popoverPresentationController!.delegate = self
        navigationController.isModalInPopover = true
        present(navigationController, animated: true, completion: nil)
        let popoverController = navigationController.popoverPresentationController
        popoverController?.passthroughViews = nil
        popoverController!.sourceView = self.view
        popoverController!.sourceRect = CGRect(x: 64,y: 160 , width: 300, height: 400)
        popoverController!.permittedArrowDirections = UIPopoverArrowDirection()

    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //pull down to refresh
        PullToRefresh.scrolling(scrollView: scrollView, vc: self)
        
        //infinite scroll
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        offSet += 10
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            
            self.isMoreDataLoading = false
            self.tweets = tweets
            self.loadingMoreView!.stopAnimating()
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            Helpers.Alert(errorMessage: error.localizedDescription, vc: self)
        })
    }
}

extension TweetsViewController: updateTweetsDelegate{
    func addTweet(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
}

