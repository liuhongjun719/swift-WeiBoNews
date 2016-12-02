//
//  HJHotSectionFooterView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/29.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit

class HJHotSectionFooterView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(footerTitle)

        footerTitle.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.left.right.equalTo(self)
            make.center.equalTo(self)
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - UI
    lazy var footerTitle: UILabel = {
        let footerTitle = UILabel()
        footerTitle.text = "点击热榜按钮，紧追微博热点"
        footerTitle.textAlignment = .center
        footerTitle.textColor = UIColor.init(red: 161/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        footerTitle.font = UIFont.systemFont(ofSize: 12)
        return footerTitle
    }()
    
    
    
    
    
    
    
    
    
}
