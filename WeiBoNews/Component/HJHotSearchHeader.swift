//
//  HJHotSearchHeader.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/29.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit

class HJHotSearchHeader: UIView {
    
    //点击搜索
    typealias SearchHeaderDidClickedBlock = () -> Swift.Void
    var searchHeaderDidClickedBlock: SearchHeaderDidClickedBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.tag = 100
        self.addSubview(titleView)
        titleView.addSubview(placeholder)
        titleView.addSubview(searchImage)
        titleView.addGestureRecognizer(tapHeaderGesture)

        
        let size = placeholder.text?.getStringSize(fontSize: 12, height: placeholder.frame.height)
        
        titleView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
        placeholder.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.center.equalTo(titleView)
            make.width.equalTo((size?.width)! + 20)
        }
        searchImage.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(10)
            make.top.equalTo(placeholder).offset(5)
            make.bottom.equalTo(placeholder).offset(-5)
            make.right.equalTo(placeholder.snp.left)
        }
        
        layoutIfNeeded()
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 点击搜索
    func searchHeaderDidClicked() {
        if let block = searchHeaderDidClickedBlock {
            block()
        }
    }
    
    
    
    //MARK: - UI
    lazy var titleView: UIView = {
       let titleView = UIView()
        titleView.layer.cornerRadius = 4
        titleView.layer.masksToBounds = true
        titleView.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        return titleView
    }()
    
    lazy var searchImage: UIImageView = {
        let searchImage = UIImageView()
        searchImage.image = UIImage(named: "search_ic01_normal")
        return searchImage
    }()
    
    lazy var placeholder: UILabel = {
        let placeholder = UILabel()
        placeholder.text = "搜一搜，找到你最想看的内容"
        placeholder.textAlignment = .center
        placeholder.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        placeholder.font = UIFont.systemFont(ofSize: 12)
        return placeholder
    }()
    
    lazy var tapHeaderGesture: UITapGestureRecognizer = {
        let tapHeaderGesture = UITapGestureRecognizer.init(target: self, action: #selector(HJHotSearchHeader.searchHeaderDidClicked))
        return tapHeaderGesture
    }()
    
    
    
    
    
    
    
    
    
}
