
//
//  MyCategoryChannelView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/18.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class MyCategoryChannelView: UICollectionReusableView {
    
    var headerTitle: UILabel!
    var editBtn: UIButton!
    var isEdit: Bool!
    
    //创建block变量
    typealias EditBtnDidClickBlock = (_ isEdit: Bool) -> Swift.Void
    var editBtnDidClickBlock:EditBtnDidClickBlock!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        isEdit = false
        
        let headerTitle = UILabel()
        headerTitle.text = "我的频道"
        headerTitle.frame = CGRect.init(x: 0, y: 0, width: 100, height: 30)
        headerTitle.backgroundColor = UIColor.clear
        headerTitle.font = UIFont.systemFont(ofSize: 13)
        headerTitle.textAlignment = .left
        headerTitle.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        self.addSubview(headerTitle)
        
        
        editBtn = UIButton()
        editBtn.frame = CGRect.init(x: self.frame.size.width-50, y: 0, width: 50, height: 30)
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitle("完成", for: .selected)

        editBtn.setTitleColor(UIColor.init(red: 255/255.0, green: 126/255.0, blue: 28/255.0, alpha: 1.0), for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        editBtn.addTarget(self, action: #selector(MyCategoryChannelView.editMyChannel), for: .touchUpInside)

        self.addSubview(editBtn)

    }
    
    
    func editMyChannel(sender: UIButton) {
        isEdit = !isEdit
        sender.isSelected = isEdit
        if let block = editBtnDidClickBlock {
            block(isEdit)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    lazy var headerTitle: UILabel = {
        let headerTitle = UILabel()
        headerTitle.backgroundColor = UIColor.clear
        headerTitle.font = UIFont.systemFont(ofSize: 13)
        headerTitle.textAlignment = .left
        headerTitle.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        return headerTitle
    }()
    
    lazy var editBtn: UIButton = {
        let editBtn = UIButton()
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitleColor(UIColor.init(red: 255/255.0, green: 126/255.0, blue: 28/255.0, alpha: 1.0), for: .normal)
        editBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return editBtn
    }()
    */

}
