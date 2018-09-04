//
//  HomeViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/22/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController{
    
    override func viewDidLoad() {
         super.viewDidLoad()
         let keys = VideoDataStore.shared.keys()
         if keys.isEmpty{
            let videoTitle = UserDefaults.standard.string(forKey: "video_title")
            let videoUrl = UserDefaults.standard.string(forKey: "video_url")
            let value =  VideoItem(title: videoTitle!, url: videoUrl!)
            VideoDataStore.shared.set(key: "0", value: value)
        }
        
        //get the default word limit if not existing
        if let wordLimit: String = VideoDataStore.shared.get(key: VideoDataStore.WordLimit){
            print("Current word Limit: \(wordLimit)")
        }
        else{
            let defaultWordLimit = UserDefaults.standard.string(forKey: "default_word_limit")
            VideoDataStore.shared.set(key: VideoDataStore.WordLimit, value: defaultWordLimit!)
            print("Default word limit : \(defaultWordLimit)")
        }
        
    }
}
