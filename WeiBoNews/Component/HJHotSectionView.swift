//
//  HJHotSectionView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/29.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit

class HJHotSectionView: UIView {
    
    var modelItem: ModelItem! {
        didSet {

            let titleText = "#" + modelItem.title! + "#"
   
            title.text = titleText
            heat.attributedText =  modelItem.heat!.getAttributeString().1

            
            let titleSize = titleText.getStringSize(fontSize: 13, height: title.frame.size.height)
            let heatSize =  modelItem.heat!.getAttributeString().0.getStringSize(fontSize: 17, height: heat.frame.size.height)

            
            title.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(titleSize.width+5)
                make.left.equalTo(titleView).offset(5)
                make.top.bottom.equalTo(title.superview!)
            }
            

            columnSeprator.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(0.5)
                make.top.equalTo(columnSeprator.superview!).offset(3)
                make.bottom.equalTo(columnSeprator.superview!).offset(-3)
                make.left.equalTo(title.snp.right).offset(5)
            }
            
            heat.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(heatSize.width+5)
                make.left.equalTo(columnSeprator.snp.right).offset(5)
                make.top.bottom.equalTo(heat.superview!)
            }
            
            titleView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(titleSize.width+5+6+heatSize.width+5+15)
                make.height.equalTo(25)
                make.centerX.equalTo(self)
                make.centerY.equalTo(self).offset(5)
            }

            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(headerSeprator)
        self.addSubview(titleView)
        titleView.addSubview(title)
        titleView.addSubview(columnSeprator)
        titleView.addSubview(heat)
        
        headerSeprator.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(5)
            make.top.left.right.equalTo(self)
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - UI
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.init(red: 52/255.0, green: 52/255.0, blue: 52/255.0, alpha: 1.0)
        title.font = UIFont.systemFont(ofSize: 13)
        return title
    }()
    
    lazy var titleView: UIView = {
       let titleView = UIView()
        titleView.layer.cornerRadius = 12.5
        titleView.layer.masksToBounds = true
        titleView.layer.borderWidth = 0.8
        titleView.layer.borderColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0).cgColor
        return titleView
    }()
    
    lazy var columnSeprator: UIView = {
       let columnSeprator = UIView()
        columnSeprator.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        return columnSeprator
    }()
    
    
    lazy var heat: UILabel = {
       let heat = UILabel()
        heat.textColor = UIColor.orange
        heat.font = UIFont.systemFont(ofSize: 17)
        return heat
    }()
    
    lazy var headerSeprator: UIView = {
        let headerSeprator = UIView()
        headerSeprator.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        return headerSeprator
    }()
    

    

    
    
    
    
    
}
