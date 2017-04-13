//
//  PullToRefresh.swift
//  TwitterClone
//
//  Created by Brandon on 4/12/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import Foundation
import UIKit

class PullToRefresh {
    
    static func setupRefreshControl(vc: TweetsViewController) {
        
        // Setup the loading view, which will hold the moving graphics
        vc.refreshLoadingView = UIView(frame: vc.refreshControl!.bounds)
        vc.refreshLoadingView.backgroundColor = UIColor.clear
        
        // Setup the color view, which will display the rainbowed background
        vc.refreshColorView = UIView(frame: vc.refreshControl!.bounds)
        vc.refreshColorView.backgroundColor = UIColor.clear
        vc.refreshColorView.alpha = 0.30
        
        // Create the graphic image views
        vc.compass_background = UIImageView(image: UIImage(named: "compass_background.png"))
        vc.compass_spinner = UIImageView(image: UIImage(named: "compass_spinner.png"))
        
        // Add the graphics to the loading view
        vc.refreshLoadingView.addSubview(vc.compass_background)
        vc.refreshLoadingView.addSubview(vc.compass_spinner)
        
        // Clip so the graphics don't stick out
        vc.refreshLoadingView.clipsToBounds = true;
        
        // Hide the original spinner icon
        vc.refreshControl!.tintColor = UIColor.clear
        
        // Add the loading and colors views to our refresh control
        vc.refreshControl!.addSubview(vc.refreshColorView)
        vc.refreshControl!.addSubview(vc.refreshLoadingView)
        
        // Initalize flags
        vc.isRefreshIconsOverlap = false
        vc.isRefreshAnimating = false
        
    }
    
    static func animateRefreshView(vc: TweetsViewController) {
        
        // Background color to loop through for our color view
        
        var colorArray = [UIColor.red, UIColor.blue, UIColor.purple, UIColor.cyan, UIColor.orange, UIColor.magenta]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        vc.isRefreshAnimating = true;
        
        UIView.animate(
            withDuration: Double(0.3),
            delay: Double(0.0),
            options: UIViewAnimationOptions.curveLinear,
            animations: {
                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
                vc.compass_spinner.transform = vc.compass_spinner.transform.rotated(by: CGFloat(M_PI_2))
                
                // Change the background color
                vc.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
        },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (vc.refreshControl!.isRefreshing) {
                    self.animateRefreshView(vc: vc)
                }else {
                    self.resetAnimation(vc: vc)
                }
        }
        )
    }
    
    static func scrolling(scrollView: UIScrollView, vc: TweetsViewController) {
        
        // Get the current size of the refresh controller
        var refreshBounds = vc.refreshControl!.bounds;
        
        // Distance the table has been pulled >= 0
        let pullDistance = max(0.0, -vc.refreshControl!.frame.origin.y);
        
        // Half the width of the table
        let midX = vc.tableView.frame.size.width / 2.0;
        
        // Calculate the width and height of our graphics
        let compassHeight = vc.compass_background.bounds.size.height;
        let compassHeightHalf = compassHeight / 2.0;
        
        let compassWidth = vc.compass_background.bounds.size.width;
        let compassWidthHalf = compassWidth / 2.0;
        
        let spinnerHeight = vc.compass_spinner.bounds.size.height;
        let spinnerHeightHalf = spinnerHeight / 2.0;
        
        let spinnerWidth = vc.compass_spinner.bounds.size.width;
        let spinnerWidthHalf = spinnerWidth / 2.0;
        
        // Calculate the pull ratio, between 0.0-1.0
        let pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
        
        // Set the Y coord of the graphics, based on pull distance
        let compassY = pullDistance / 2.0 - compassHeightHalf;
        let spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
        
        // Calculate the X coord of the graphics, adjust based on pull ratio
        var compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
        var spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
        
        // When the compass and spinner overlap, keep them together
        if (fabsf(Float(compassX - spinnerX)) < 1.0) {
            vc.isRefreshIconsOverlap = true;
        }
        
        // If the graphics have overlapped or we are refreshing, keep them together
        if (vc.isRefreshIconsOverlap || vc.refreshControl!.isRefreshing) {
            compassX = midX - compassWidthHalf;
            spinnerX = midX - spinnerWidthHalf;
        }
        
        // Set the graphic's frames
        var compassFrame = vc.compass_background.frame;
        compassFrame.origin.x = compassX;
        compassFrame.origin.y = compassY;
        
        var spinnerFrame = vc.compass_spinner.frame;
        spinnerFrame.origin.x = spinnerX;
        spinnerFrame.origin.y = spinnerY;
        
        vc.compass_background.frame = compassFrame;
        vc.compass_spinner.frame = spinnerFrame;
        
        // Set the encompassing view's frames
        refreshBounds.size.height = pullDistance;
        
        vc.refreshColorView.frame = refreshBounds;
        vc.refreshLoadingView.frame = refreshBounds;
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (vc.refreshControl!.isRefreshing && !vc.isRefreshAnimating) {
            PullToRefresh.animateRefreshView(vc: vc)
        }
    }
    
    static func resetAnimation(vc : TweetsViewController) {
        
        // Reset our flags and }background color
        vc.isRefreshAnimating = false;
        vc.isRefreshIconsOverlap = false;
        vc.refreshColorView.backgroundColor = UIColor.clear
    }
}
