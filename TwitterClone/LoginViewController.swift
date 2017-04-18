//
//  LoginViewController.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logo.center.x -= view.bounds.width
        UIView.animate(withDuration: 0.8, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.logo.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.login(success: { () -> Void in
            print("I've logged in")
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
        }) { (error: Error) -> Void in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    //sends you to twitter site to sign up. If you are already logged in it will take you to your home screen
    @IBAction func onSignUpButton(_ sender: Any) {
        
        UIApplication.shared.openURL(NSURL(string: "https://twitter.com/signup?lang=en")! as URL)
    }
}
