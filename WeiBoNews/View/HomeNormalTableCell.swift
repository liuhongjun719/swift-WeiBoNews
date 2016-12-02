//
//  HomeNormalTableCell.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/14.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import ZFPlayer

class HomeNormalTableCell: UITableViewCell {
    var modelItem: ModelItem! {
        didSet {
            let titleText = modelItem.title

            title.text = titleText
            source.text = modelItem.source
            
            if modelItem.images_count != nil && modelItem.images_count! > 0 {
                showImage.sd_setImage(with: URL(string: (modelItem.image_240?[0].des_url!)!), placeholderImage: nil)
            }
            
            let titleSize = titleText?.getStringSizeWithWidth(fontSize: 16, width: 0)
            
            separatorLine.snp.makeConstraints { (make) in
                make.left.equalTo(self).offset(10)
                make.right.equalTo(self).offset(-10)
                make.bottom.equalTo(self)
                make.height.equalTo(0.8)
            }
            
            
            
            showImage.snp.makeConstraints { (make) in
                make.top.equalTo(self).offset(10)
                make.bottom.equalTo(separatorLine).offset(-10)
                make.right.equalTo(separatorLine)
                make.width.equalTo(120)
            }
            
            source.snp.makeConstraints { (make) in
                make.bottom.equalTo(showImage)
                make.left.equalTo(separatorLine)
                make.right.equalTo(showImage.snp.left).offset(-10)
                make.height.equalTo(15)
            }
            
            title.snp.makeConstraints { (make) in
                make.top.equalTo(showImage)
                make.left.equalTo(source)
                make.right.equalTo(source)
                make.height.equalTo((titleSize?.height)!).priority(700)
            }
            
            
        }
    }
    
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.addSubview(showImage)
        self.addSubview(title)
        self.addSubview(source)
        self.addSubview(separatorLine)
        
        layoutIfNeeded()
    }
    
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSepratorColor(index:Int) {
        if index % 2 != 0 {
            separatorLine.backgroundColor = UIColor.white
        }else {
            separatorLine.backgroundColor = UIColor.init(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)
            
        }
    }
    
    lazy var showImage: UIImageView = {
        let showImage = UIImageView()
        return showImage
    }()
    
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.init(red: 30/255.0, green: 45/255.0, blue: 62/255.0, alpha: 1.0)
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 16)
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
