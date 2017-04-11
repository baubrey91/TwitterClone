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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onLoginButton(_ sender: Any) {
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: requestTokenURL,
                                         method: "GET",
                                         callbackURL: URL(string: "twitterclone://oauth"),
                                         scope: nil,
                                         success: { (requestToken: BDBOAuth1Credential?) -> Void in
                                            print("Token acquired")
                                            let url = URL(string: "\(baseURL)\(authorize)\(requestToken!.token!)")!
                                            UIApplication.shared.open(url)
        }) { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
        }
    }

}
