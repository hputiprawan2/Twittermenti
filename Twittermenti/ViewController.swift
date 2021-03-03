//
//  ViewController.swift
//  Twittermenti
//
//  Created by Hanna Putiprawan on 03/01/21.
//

import UIKit
import SwifteriOS

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let swifter = Swifter(consumerKey: "91TSj3HgnUtY8CHKSsvPlasrJ", consumerSecret: "M0rxJG8ohNR8z0Ius4BJml5GttNRXNUdniatfZkiRGrIJWGRd5")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended) { (result, metadata) in
            print(result)
        } failure: { (error) in
            print("There was an error with the Twitter API request, \(error)")
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    }
    
}

