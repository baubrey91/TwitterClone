//
//  Helpers.swift
//  TwitterClone
//
//  Created by Brandon Aubrey on 4/15/17.
//  Copyright © 2017 Brandon. All rights reserved.
//

import Foundation
import UIKit

class Helpers {
    static func alertMessage(errorMessage: String, vc: UIViewController) {
        let ac = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        vc.present(ac, animated: true, completion: nil)
    }
}
