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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateVideoData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func populateVideoData(){
        let videoItems = VideoDataStore.shared.values()
        for item in videoItems{
            if Utils.verifyUrl(urlString: item.url){
                let url = URL(string: item.url)
                dataSource.append(VideoData(title: item.title, videoUrl: url))
            }
        }
        
        if !dataSource.isEmpty {
            let firstIndexPath = IndexPath(row: 0, section: 0)
            self.tableView.selectRow(at: firstIndexPath, animated: true, scrollPosition: .top)
            self.rowSelected(data: dataSource[0])
        }
    }
}

extension VideoTableViewController {
    
    //MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count// + 1
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
