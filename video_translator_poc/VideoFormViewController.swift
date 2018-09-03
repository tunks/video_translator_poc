//
//  VideoFormViewController.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import Eureka


struct VideoItem: Equatable{
    var title: String?
    var url: String?
    var language: String?
}
class VideoFormViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ Section()
            <<< VideoItemRow { row in
                row.value = VideoItem(title: "Video Title 1",
                                      url: "http://lh4.ggpht.com/VpeucXbRtK2pmVY6At76vU45Q7YWXB6kz25Sm_JKW1tgfmJDP3gSAlDwowjGEORSM-EW=w300",
                                      language: "English")
            }
        
//        form +++
//            MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
//                               header: "Multivalued TextField",
//                               footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") {
//                                $0.addButtonProvider = { section in
//                                    return ButtonRow(){
//                                        $0.title = "Add New Tag"
//                                    }
//                                }
//                                $0.multivaluedRowToInsertAt = { index in
//                                    return NameRow() {
//                                        $0.placeholder = "Tag Name"
//                                    }
//                                }
//                                $0.multivaluedRowToInsertAt = { index in
//                                    return NameRow() {
//                                        $0.placeholder = "Tag Name2"
//                                    }
//                                }
//                                $0 <<< NameRow() {
//                                    $0.placeholder = "Tag Name"
//                                }
//        }
    }
}
