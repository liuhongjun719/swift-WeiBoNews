//
//  SubscribeChannelView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/18.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class SubscribeChannelView: UICollectionReusableView {
    
    var headerTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        let headerTitle = UILabel()
        headerTitle.text = "订阅频道"
        headerTitle.frame = CGRect.init(x: 0, y: 0, width: 100, height: 30)
        headerTitle.backgroundColor = UIColor.clear
        headerTitle.font = UIFont.systemFont(ofSize: 13)
        headerTitle.textAlignment = .left
        headerTitle.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        self.addSubview(headerTitle)
  
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}
