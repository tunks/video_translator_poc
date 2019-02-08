//
//  VideoItemCell.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import Eureka
import iOSDropDown

final class VideoItemCell: Cell<VideoItem>, CellType {
    
    @IBOutlet weak var videoTitleTextField: UITextField!
    
    @IBOutlet weak var videoUrlTextField: UITextField!
    
    @IBOutlet weak var videoLanguageDropdown: DropDown!
    
    required init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
        height = { return 230 }
        
        videoLanguageDropdown.optionArray = Utils.SupportedLangauges
        videoLanguageDropdown.text = Utils.SupportedLangauges[2]

        //UIControlEvents
        videoTitleTextField.addTarget(self, action: #selector(videoTitleChanged), for: .editingDidEnd)
        videoUrlTextField.addTarget(self, action: #selector(videoUrlChanged), for: .editingDidEnd)
        //videoLanguageTextField.addTarget(self, action: #selector(videoLanguageChanged), for: .editingDidEnd)
        videoLanguageDropdown.didSelect{(selectedText , index ,id) in
            self.videoLanguageChanged(selectedText)
        }
    }
    
    override func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
        
        // get the value from our row
        guard let info: VideoItem = row.value else { return }
        self.videoTitleTextField.text =  info.title
        self.videoUrlTextField.text = info.url
        self.videoLanguageDropdown.text = info.language
    }
    
    @objc func videoTitleChanged(){
        if let text = videoTitleTextField.text, !(videoTitleTextField.text?.isEmpty)! {
           let data = VideoItem(title: text, url: videoUrlTextField.text!)
           storeVideoInfo(data)
        }
    }
    
    @objc func videoTitleEditingBegin(_ textField: UITextField){
        formViewController()?.beginEditing(of: self)
        formViewController()?.textInputDidBeginEditing(textField, cell: self)
    }
    
    @objc func videoUrlChanged(){
        if let text = videoUrlTextField.text, !(videoUrlTextField.text?.isEmpty)! {
           let data = VideoItem(title: videoTitleTextField.text!, url: text)
           storeVideoInfo(data)
        }
    }
    
    func videoLanguageChanged(_ text: String){
         let data = VideoItem(title: videoTitleTextField.text!, url: videoUrlTextField.text!, language: text)
         storeVideoInfo(data)
    }
    
    private func storeVideoInfo(_ data: VideoItem){
        if let number = row.indexPath?.item, !(row.indexPath?.isEmpty)! {
           let key = String(number)
           //print("store value \(key): \(data)")
           VideoDataStore.shared.set(key: key, value: data)
        }
    }
}
