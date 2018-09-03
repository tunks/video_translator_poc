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
        
        // configure our profile picture imageView
        //videoTitleTextField.contentMode =  .scaleAspectFill
        
        // define fonts for our labels
        
        // set the textColor for our labels
//        for label in [emailLabel, dateLabel, nameLabel] {
//            label?.textColor = .gray
//        }
        
        // specify the desired height for our cell
          height = { return 120 }
        
        // set a light background color for our cell
        //backgroundColor = UIColor(red:0.984, green:0.988, blue:0.976, alpha:1.00)
    }
    
    override func update() {
        super.update()
        // we do not want to show the default UITableViewCell's textLabel
        textLabel?.text = nil
        
        // get the value from our row
        guard let videoInfo: VideoItem = row.value else { return }

        self.videoTitleTextField.text =  videoInfo.title
        self.videoUrlTextField.text = videoInfo.url
    }
}
