//
//  CategoryCell.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/16.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
//    var isEdit: Bool?
//    var menuInfo: MenuInfo! {
//        didSet {
//            categoryName.text = menuInfo.name
//            
//            //判断cell是否可编辑
//            if isEdit == true {
//                deleteBtn.isHidden = false
//            }else {
//                deleteBtn.isHidden = true
//            }
//
//            
//        }
//    }
//    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(categoryName)
        self.addSubview(deleteBtn)
        
        categoryName.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
        deleteBtn.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.width.height.equalTo(10)
        }
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var categoryName: UILabel = {
        let categoryName = UILabel()
        categoryName.textAlignment = .center
        categoryName.font = UIFont.systemFont(ofSize: 15)
        categoryName.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        categoryName.layer.cornerRadius = 15
        categoryName.layer.masksToBounds = true
        return categoryName
    }()
    
    lazy var deleteBtn: UIButton = {
        let deleteBtn = UIButton()
        deleteBtn.setImage(UIImage(named: "channel_btn_del_normal"), for: .normal)
        deleteBtn.setImage(UIImage(named: "channel_btn_del_pressed"), for: .selected)
        return deleteBtn
    }()
    
    //MARK: - 刷新数据
    //我的频道
    func reloadCell(item: MenuInfo, isEdit: Bool, currentPageIndex: Int, cellIndex: Int) {
        categoryName.text = item.name
        if currentPageIndex == cellIndex{
            categoryName.textColor = UIColor.orange
        }else {
            categoryName.textColor = UIColor.black
        }
        
        //判断cell是否可编辑
        if isEdit == true {
            deleteBtn.isHidden = false
        }else {
            deleteBtn.isHidden = true
        }
        
    }
    
    //订阅频道
    func reloadCellWithSubscripeChannel(item: MenuInfo) {
        categoryName.text = item.name
        categoryName.textColor = UIColor.black
        deleteBtn.isHidden = true
    }

}


