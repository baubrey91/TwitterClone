//
//  ViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
    
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
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            
            self.tweets = tweets
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    func refresh(){
        
        // This is where you'll make requests to an API, reload data, or process information
        let delayInSeconds = 3.0;
        let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC);
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            // When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.refreshControl!.endRefreshing()
        }
    }
    

    @IBAction func onLogoutButton(_ sender: Any) {
        
            TwitterClient.sharedInstance?.logout()
    }
}

extension TweetsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //PullToRefresh.scrolling(scrollView: scrollView, vc: self)
        
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
        //filters["offset"] = offSet as AnyObject
        print("working")
    }

}

