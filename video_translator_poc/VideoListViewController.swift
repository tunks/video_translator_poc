//
//  VideoListViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/22/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class VideoListViewController: UIViewController{
    private var langNotification =  Notification.Name("SELECTED_LANGUAGE")
    //let languages = ["English","French","Spanish","Arabic"]

    @IBOutlet weak var languageControl: UISegmentedControl!
    
    @IBAction func languageSelected(_ sender: UISegmentedControl) {
        let title =  languageControl.titleForSegment(at: sender.selectedSegmentIndex)
        NotificationCenter.default.post(name: langNotification,
                                        object: nil,
                                        userInfo: ["data": title!])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        languageControl.setEnabled(false, forSegmentAt: 0)
    }
}

