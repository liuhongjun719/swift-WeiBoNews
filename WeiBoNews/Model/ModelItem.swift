//
//  ModelItem.swift
//  SwiftSouthWeekend
//
//  Created by 123456 on 16/10/21.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import ObjectMapper

class ModelItem: Mappable {

    //home 页
    var title: String?
    var source: String?//*网
    var image_240: [Image240Item]?
    var images_count: Int?
    var videos: [VideosItem]?
    var article_url: String?//闪读
    var original_url: String?//原文
    var likes_count: Int?
    var plays_count: Int?
    
    
    //home detail页item
    var content_oid: String?
    var followed: Bool?
    var image: [String:String]?
    var name: String?
    var share: [String:String]?
    var share_url: String?

    //hot
    var attributes: ModelItem?//原文
    var heat: Int?

    
    
    

    
    required init?(map: Map){

    }
    
    func mapping(map: Map) {
        title <- map["title"]
        source <- map["source"]
        image_240 <- map["image_240"]
        images_count <- map["images_count"]
        videos <- map["videos"]
        article_url <- map["article_url"]
        
        content_oid <- map["content_oid"]
        followed <- map["followed"]
        image <- map["image"]
        name <- map["name"]
        share <- map["share"]
        article_url <- map["article_url"]
        original_url <- map["original_url"]
        attributes <- map["attributes"]
        heat <- map["heat"]
        likes_count <- map["likes_count"]
        plays_count <- map["plays_count"]

    }
  
}
