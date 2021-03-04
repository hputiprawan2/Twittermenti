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

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
    fatalError("Couldn't find file 'Config.plist'.")
        }
     
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_Key") as? String else {
            fatalError("Couldn't find key 'API_Key' in 'Config.plist'.")
            }
            return value
        }
    }

    private var apiKeySecret: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Config", ofType: "plist") else {
    fatalError("Couldn't find file 'Config.plist'.")
        }
     
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_Key_Secret") as? String else {
            fatalError("Couldn't find key 'API_Key_Secret' in 'Config.plist'.")
            }
            return value
        }
    }

    var swifter = Swifter(consumerKey: "dummy_key", consumerSecret: "dummy_key")
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.delegate = self
        swifter = Swifter(consumerKey: apiKey, consumerSecret: apiKeySecret)
    }
    
    // Pressed enter instead of click the predict button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        fetchTweets()
        return true
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    private func fetchTweets() {
        if let searchText = textField.text {
            swifter.searchTweet(using: searchText, lang: "en", count: tweetCount, tweetMode: .extended) { (result, metadata) in
                var tweets = [TweetSentimentClassifierInput]()
                for i in 0..<self.tweetCount {
                    if let tweet = result[i]["full_text"].string {
                        // Convert Sting input into TweetSentimentClassifierInput
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                    self.makePrediction(with: tweets)
                }
                
            } failure: { (error) in
                print("There was an error with the Twitter API request, \(error)")
            }

        }
    }
    
    private func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        do {
            let predictions = try self.sentimentClassifier.predictions(inputs: tweets)
            var sentimentScore = 0
            for prediction in predictions {
                let sentiment = prediction.label
                if sentiment == "Pos" {
                    sentimentScore += 1
                } else if sentiment == "Neg" {
                    sentimentScore -= 1
                }
            }
            updateUI(with: sentimentScore)
        } catch {
            print("There was an error with making a prediction, \(error)")
        }
    }
    
    private func updateUI(with sentimentScore: Int) {
        if sentimentScore > 20 {
            self.sentimentLabel.text = "😍"
        } else if sentimentScore > 10 {
            self.sentimentLabel.text = "😄"
        } else if sentimentScore > 0 {
            self.sentimentLabel.text = "🙂"
        } else if sentimentScore == 0 {
            self.sentimentLabel.text = "😐"
        } else if sentimentScore > -10 {
            self.sentimentLabel.text = "😕"
        } else if sentimentScore > -20 {
            self.sentimentLabel.text = "😡"
        } else {
            self.sentimentLabel.text = "🤬"
        }
    }
}

