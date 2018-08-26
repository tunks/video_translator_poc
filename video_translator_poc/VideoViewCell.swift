//
//  VideoCell.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/23/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class VideoViewCell: UITableViewCell{
    
    @IBOutlet weak var label: UILabel!
    var videoUrl: URL?
    
    static let VideoNotification = Notification.Name("PLAY_VIDEO")
}
