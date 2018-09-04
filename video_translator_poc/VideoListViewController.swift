//
//  VideoListViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/22/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit
import MarqueeLabel
import iOSDropDown
class VideoListViewController: UIViewController{
    
    @IBOutlet weak var subtitleLabel: MarqueeLabel!
       
    @IBOutlet weak var dropDown: DropDown!
    
    @IBOutlet weak var translateSwitch: UISwitch!
    
    //private let langauges = ["Chinese","French", "Hindi", "Spanish"]
  
    var translate: Bool?{
        didSet{
            NotificationCenter.default.post(name: Utils.TranslateNotification, object: nil, userInfo: ["data" : translate!])
        }
    }
    
    @IBAction func translateActionToggle(_ sender: UISwitch) {
        translate = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The list of array to display. Can be changed dynamically
        dropDown.optionArray = Utils.SupportedLangauges
        //Its Id Values and its optional
        // The the Closure returns Selected Index and String
        dropDown.text = Utils.SupportedLangauges[1]
        dropDown.didSelect{(selectedText , index ,id) in
            self.languageSelected(language: selectedText)
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //subtitleLabel. //translateLabel.type = .leftRight
        subtitleLabel.speed = .rate(80.0)
        //translateLabel.fadeLength = 80.0
        subtitleLabel.labelWillBeginScroll()
        subtitleLabel.restartLabel()
        //LabelTextNotification
        NotificationCenter.default.addObserver(self,selector: #selector(updateSubtitleLabel(_:)),
                                               name: Utils.LabelTextNotification,
                                               object: nil)
        self.translate = translateSwitch.isOn
        self.subtitleLabel.text = ""
         //dropDown.showList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Utils.LabelTextNotification, object: nil)
    }
    
    @objc private func updateSubtitleLabel( _ notification : NSNotification){
        let text = notification.userInfo!["data"] as! String
        DispatchQueue.main.async {
             self.subtitleLabel.text = text
        }
       // self.subtitleLabel.text = text
    }
    
    
    private func languageSelected(language: String) {
        NotificationCenter.default.post(name:  Utils.LanguageNotification,
                                        object: nil,
                                        userInfo: ["data": language])
    }
    
    private func refreshVideoTableView(){
        if let ctrl: VideoTableViewController = storyboard?.instantiateViewController(withIdentifier: "VideoTableViewController")
                    as? VideoTableViewController {
              ctrl.refreshControl?.beginRefreshing()
        }
    }
    
}

