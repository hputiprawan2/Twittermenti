//
//  File.swift
//  Twittermenti
//
//  Created by Hanna Putiprawan on 3/2/21.
//

import Foundation

struct MyConfig: Decodable {
    private enum CodingKeys: String, CodingKey {
        case API_Key, API_Key_Secret
    }
    let API_Key: String
    let API_Key_Secret: String
    
    func loadAPIKey(){
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let xml  = FileManager.default.contents(atPath: path),
            let settings = try? PropertyListDecoder().decode(MyConfig.self, from: xml) {
            print(settings.API_Key)
            print(settings.API_Key_Secret)
        }

    }
}
