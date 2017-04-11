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
    
    init(dictionary: NSDictionary){
        
        name = dictionary["name"] as? String
        screename = dictionary["screen_name"] as? String
        
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        
        tagline = dictionary["description"] as? String
        
    }

}
