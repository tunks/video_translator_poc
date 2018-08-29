//
//  VideoTableViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 8/23/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class VideoTableViewController: UITableViewController{
    struct VideoData {
        var title: String?
        var videoUrl: URL?
    }
    var dataSource: [VideoData] = []
    var videoItems: [String:String] = [
                                      /* "innovations_Unlimited.mp4": "AT&T Innovations: Unlimited Deliveries",
                                       "Innovations_productive.mp4":"AT&T Innovations: It's Productive",*/
                                       "Fiber_multi_family.mp4": "AT&T Fiber for Multi-family Properties"
                                       ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in videoItems{
            let names = item.key.components(separatedBy: ".")
            let url = Bundle.main.url(forResource: "video/"+names[0], withExtension: names[1])
            dataSource.append(VideoData(title: item.value, videoUrl: url))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let firstIndexPath = IndexPath(row: 0, section: 0)
        self.tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .top)
        self.rowSelected(data: dataSource[0])
    }
}

extension VideoTableViewController {
    
    //MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let videoCell = tableView.dequeueReusableCell(withIdentifier: "VideoViewCell") as! VideoViewCell
        videoCell.label.text = dataSource[indexPath.row].title
        videoCell.videoUrl = dataSource[indexPath.row].videoUrl
        return videoCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select row at \(indexPath.row)")
       // let videoCell: VideoViewCell = tableView.cellForRow(at: indexPath) as! VideoViewCell;
        rowSelected(data: dataSource[indexPath.row])
    }
    
    func rowSelected( data: VideoData){
     NotificationCenter.default.post(name: VideoViewCell.VideoNotification, object: nil,
                                     userInfo: ["data" : data])
        //print("send notification url: \(data.videoUrl)")
    }
}
