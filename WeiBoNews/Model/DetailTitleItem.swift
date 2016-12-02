//
//  DetailTitleItem.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/24.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import ObjectMapper


class DetailTitleItem: Mappable {
    var abstract: String?
    var tags: [ModelItem]?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        abstract <- map["abstract"]
        tags <- map["tags"]
    }
  
}
