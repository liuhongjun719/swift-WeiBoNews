//
//  NoImageTableCell.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/16.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import ZFPlayer

class NoImageTableCell: UITableViewCell {
    var modelItem: ModelItem! {
        didSet {
            let titleText = modelItem.title

            title.text = titleText
            source.text = modelItem.source
            
            let titleSize = titleText?.getStringSizeWithWidth(fontSize: 16, width: 0)

            title.snp.makeConstraints { (make) in
                make.top.equalTo(self).offset(10)
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.height.equalTo((titleSize?.height)!)
            }
            
            
            separatorLine.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self)
                make.height.equalTo(0.8)
            }
            
            source.snp.makeConstraints { (make) in
                make.left.equalTo(separatorLine)
                make.right.equalTo(separatorLine)
                make.bottom.equalTo(separatorLine.snp.top).offset(-10)
                make.height.equalTo(15)
            }
            
            
        }
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white

        self.addSubview(title)
        self.addSubview(source)
        self.addSubview(separatorLine)
        layoutIfNeeded()
        
    }
    
    
    func changeSepratorColor(index:Int) {
        if index % 2 != 0 {
            separatorLine.backgroundColor = UIColor.white
        }else {
            separatorLine.backgroundColor = UIColor.init(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)

        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    
    
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.init(red: 30/255.0, green: 45/255.0, blue: 62/255.0, alpha: 1.0)
        title.numberOfLines = 2
        return title
    }()
    
    lazy var source: UILabel = {
        let source = UILabel()
        source.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        source.font = UIFont.systemFont(ofSize: 12)
        return source
    }()
    
    
    lazy var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.init(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)
        return separatorLine
    }()
    
    
}
