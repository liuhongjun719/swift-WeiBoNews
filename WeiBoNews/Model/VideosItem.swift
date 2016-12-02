//
//  VideosItem.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/14.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import ObjectMapper

class VideosItem: Mappable {
    
    var duration: Int?
    var img_height: Int?//*网
    var img_url: String?
    var img_width: Int?
    var object_id: String?
    var video_url: String?

    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        duration <- map["duration"]
        img_height <- map["img_height"]
        img_url <- map["img_url"]
        img_width <- map["img_width"]
        object_id <- map["object_id"]
        video_url <- map["video_url"]
    }
    
}

