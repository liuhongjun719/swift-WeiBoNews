//
//  ContainThreeImageCell.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/16.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import ZFPlayer

class ContainThreeImageCell: UITableViewCell {
    var modelItem: ModelItem! {
        didSet {
            title.text = modelItem.title
            source.text = modelItem.source
            
            if modelItem.images_count != nil && modelItem.images_count! > 0 {
                firstImage.sd_setImage(with: URL(string: (modelItem.image_240?[0].des_url!)!), placeholderImage: nil)
                secondImage.sd_setImage(with: URL(string: (modelItem.image_240?[1].des_url!)!), placeholderImage: nil)
                thirdImage.sd_setImage(with: URL(string: (modelItem.image_240?[2].des_url!)!), placeholderImage: nil)
            }
            
        }
    }
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.addSubview(firstImage)
        self.addSubview(secondImage)
        self.addSubview(thirdImage)
        self.addSubview(title)
        self.addSubview(source)
        self.addSubview(separatorLine)
        
        
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(30)
        }
        
        firstImage.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(title)
            make.height.equalTo(90)
            make.width.equalTo((self.frame.size.width+30)/3)
        }
        

        
        thirdImage.snp.makeConstraints { (make) in
            make.top.equalTo(firstImage)
            make.width.equalTo((self.frame.size.width+30)/3)
            make.height.equalTo(90)
            make.right.equalTo(title)
        }
        
        secondImage.snp.makeConstraints { (make) in
            make.top.equalTo(firstImage)
            make.left.equalTo(firstImage.snp.right).offset(5)
            make.height.equalTo(90)
            make.right.equalTo(thirdImage.snp.left).offset(-5)
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
    
    
    //MARK: - 改变热榜界面的分割线颜色
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
    
    
    
    lazy var firstImage: UIImageView = {
        let firstImage = UIImageView()
        return firstImage
    }()
    
    lazy var secondImage: UIImageView = {
       let secondImage = UIImageView()
        return secondImage
    }()
    
    lazy var thirdImage: UIImageView = {
        let thirdImage = UIImageView()
        return thirdImage
    }()
    
    
    
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
