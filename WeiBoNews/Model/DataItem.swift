//
//  DataItem.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/11.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import ObjectMapper

class DataItem: Mappable {
    var data: [ModelItem]?
    var included: [ModelItem]?
    
    
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        data <- map["data"]
        included <- map["included"]
    }
    
  
}
