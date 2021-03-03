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
        
        swifter.searchTweet(using: "@Apple", lang: "en", count: 100, tweetMode: .extended) { (result, metadata) in
            var tweets = [TweetSentimentClassifierInput]()
            for i in 0..<100 {
                if let tweet = result[i]["full_text"].string {
                    // Convert Sting input into TweetSentimentClassifierInput
                    let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                    tweets.append(tweetForClassification)
                }
                
            }
            do {
                let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
                for prediction in predictions {
                    print(prediction.label)
                }
            } catch {
                print("There was an error with making a prediction, \(error)")
            }
        } failure: { (error) in
            print("There was an error with the Twitter API request, \(error)")
        }

    }

    @IBAction func predictPressed(_ sender: Any) {
    
    }
    
}

