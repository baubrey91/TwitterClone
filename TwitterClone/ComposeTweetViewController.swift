//
//  ComposeTweetViewController.swift
//  TwitterClone
//
//  Created by Brandon Aubrey on 4/14/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit
import AVFoundation

//send data foreward with segues and back with protocols
protocol updateTweetsDelegate {
    func addTweet(tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {
    
    //connections
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var retweetNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var replyingToLabel: UILabel!

    //variables
    var delegate: updateTweetsDelegate?
    var replyingTo: String?
    var replyID: String?
    let utterance = AVSpeechUtterance(string: "TWEET TWEET")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.6

        profileImage.setImageWith((User.currentUser?.profileUrl)!)
        profileImage.layer.cornerRadius = 9.0
        profileImage.layer.masksToBounds = true
        nameLabel.text = User.currentUser?.name
        screenNameLabel.text = "@" + (User.currentUser?.screename)!
        if replyingTo != nil {
            replyingToLabel.text = "replying to \(replyingTo!)"
        }

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

        TwitterClient.sharedInstance?.postTweet(tweet: status!,
                                                replyToStatusID: replyID,
                                                success: { tweet in
                                                    let speechSynthesizer = AVSpeechSynthesizer()
                                                    speechSynthesizer.speak(self.utterance)
                                                    self.delegate?.addTweet(tweet: tweet)
                                                    self.dismiss(animated: true) {

                                                    }},
                                                failure: { (error) in
                                                    Helpers.alertMessage(errorMessage: error.localizedDescription,
                                                                         vc: self)

        })
    }
}

extension ComposeTweetViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if textView.text == "Tweet about it..."{
            textView.text = ""
        }
        let charactersLeft = textView.text.utf16.count + text.utf16.count - range.length

        characterCount.text =  "\(125 - charactersLeft)"
        return charactersLeft < 125
    }
}
