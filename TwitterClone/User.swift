//
//  User.swift
//  TwitterClone
//
//  Created by Brandon on 4/10/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screename: String?
    var profileUrl: URL?
    var tagline: String?
    
    var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {

        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
    }

    static let userDidLogoutNotification = "UserDidLogout"

    static var _currentUser: User?

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard

                let userData = defaults.object(forKey: "currentUserData") as? Data

                if let userData = userData {
                    defaults.removeObject(forKey:"currentUserData")

                    let dictionary = try!
                        JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }

            return _currentUser
        }
        set(user) {

            _currentUser = user

            let defaults = UserDefaults.standard

            if let user = user {

                let data = try!
                    JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")

            } else {
                defaults.removeObject(forKey: "currentUserData")
            }

            defaults.synchronize()
        }
    }
}
