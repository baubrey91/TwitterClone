//
//  ComposeTweetViewController.swift
//  TwitterClone
//
//  Created by Brandon Aubrey on 4/14/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImage.setImageWith((User.currentUser?.profileUrl)!)
        profileImage.layer.cornerRadius = 9.0
        profileImage.layer.masksToBounds = true
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@\(String(describing: User.currentUser?.screename))"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func cancelButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendTweetButton(_ sender: Any) {
        
        let status = self.messageTextView.text
        
        var params: NSDictionary = ["status": status]
        
        //let currentText = inReplyToUserMention + messageTextView.text
        
        TwitterClient.sharedInstance?.postTweet(tweet: status!,
                                                replyToStatusID: nil,
                                                success: { tweet in
                                                    self.dismiss(animated: true) {
                                                        //self.callback?(tweet)
                                                    }},
                                                failure: { (error) in
                                                    Helpers.Alert(errorMessage: error.localizedDescription, vc: self)

        })
    }
}

extension ComposeTweetViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let charactersLeft = textView.text.utf16.count + text.utf16.count - range.length
        
        characterCount.text =  "\(125 - charactersLeft)"
        return charactersLeft < 125
    }
    

}
