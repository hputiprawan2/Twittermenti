//
//  ViewController.swift
//  Twittermenti
//
//  Created by Hanna Putiprawan on 03/01/21.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let swifter = Swifter(consumerKey: "91TSj3HgnUtY8CHKSsvPlasrJ", consumerSecret: "M0rxJG8ohNR8z0Ius4BJml5GttNRXNUdniatfZkiRGrIJWGRd5")
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let prediction = try! sentimentClassifier.prediction(text: "@Apple is the best company!")
//        print(prediction.label)
        
        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended) { (result, metadata) in
            if let tweet = result[0]["full_text"].string {
                print(tweet)
            }
        } failure: { (error) in
            print("There was an error with the Twitter API request, \(error)")
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    }
    
}

