//
//  VideoItemCell.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import Eureka

final class VideoItemCell: Cell<VideoItem>, CellType {
    
    @IBOutlet weak var videoTitleTextField: UITextField!
    
    @IBOutlet weak var videoUrlTextField: UITextField!
    
    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        // we do not want our cell to be selected in this case. If you use such a cell in a list then you might want to change this.
        selectionStyle = .none
        // specify the desired height for our cell
        height = { return 170 }
        
        // set a light background color for our cell
        //backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
        videoTitleTextField.addTarget(self, action: #selector(videoTitleChanged), for: .editingDidEnd)
        videoUrlTextField.addTarget(self, action: #selector(videoUrlChanged), for: .editingDidEnd)
    }
    
    override func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
        
        // get the value from our row
        guard let info: VideoItem = row.value else { return }
        self.videoTitleTextField.text =  info.title
        self.videoUrlTextField.text = info.url
        //videoInfo = info
        self.formViewController().tex

    }
    
    @objc func videoTitleChanged(){
        if let text = videoTitleTextField.text, !(videoTitleTextField.text?.isEmpty)! {
           let data = VideoItem(title: text, url: videoUrlTextField.text!)
           storeVideoInfo(data)
        }
    }
    
    @objc func videoUrlChanged(){
        if let text = videoUrlTextField.text, !(videoUrlTextField.text?.isEmpty)! {
            let data = VideoItem(title: videoTitleTextField.text!, url: text)
            storeVideoInfo(data)
        }
    }
    
    private func storeVideoInfo(_ data: VideoItem){
        if let number = row.indexPath?.item, !(row.indexPath?.isEmpty)! {
           let key = String(number)
           //print("store value \(key): \(data)")
           VideoDataStore.shared.set(key: key, value: data)
        }
    }
}
