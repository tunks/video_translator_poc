//
//  VideoItemRow.swift
//  video_translator_poc
//
//  Created by Ebrima Tunkara on 9/2/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import Eureka

final class  VideoItemRow: Row<VideoItemCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<VideoItemCell>(nibName: "VideoItemCell")
    }
}
