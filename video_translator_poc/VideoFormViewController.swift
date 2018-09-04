//
//  VideoFormViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import Eureka

class VideoFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //VideoDataStore.shared.clear()
        let videoItems = VideoDataStore.shared.values()
       
        form +++ Section("Translation")
            <<< TextRow(){ row in
                row.title = "Word Limit"
                row.placeholder = "Enter limit here"
                row.value = VideoDataStore.shared.get(key: VideoDataStore.WordLimit)
            }.onChange({ text in
                VideoDataStore.shared.set(key: VideoDataStore.WordLimit, value: text.value!)
            })
        
    
        form +++
            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                               header: "Video List Setting") {
                               $0.addButtonProvider = { section in
                                    return ButtonRow(){
                                        $0.title = "Add New Video Item"
                                    }
                                }
                                
                                $0.multivaluedRowToInsertAt = { index in
                                    return VideoItemRow()
                                }
                                
                                for item in videoItems{
                                    $0 <<< VideoItemRow() {
                                        $0.value = item
                                    }
                                }
        }
    }
    
    override func  rowsHaveBeenRemoved(_ rows: [BaseRow], at indexes: [IndexPath]) {
        super.rowsHaveBeenRemoved(rows, at: indexes)
        for index in indexes{
            let number: Int = index.item
            let key = String(number)
            VideoDataStore.shared.remove(key: key)
            //print("Row removed \(key)")
        }
    }

}
