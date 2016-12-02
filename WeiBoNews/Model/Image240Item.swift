//
//  Image240Item.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/14.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import ObjectMapper

class Image240Item: Mappable {
    
    var des_url: String?
    var height: String?//*网
    var width: String?
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        des_url <- map["des_url"]
        height <- map["height"]
        width <- map["width"]
    }
    
    
    
    
    
    
}
