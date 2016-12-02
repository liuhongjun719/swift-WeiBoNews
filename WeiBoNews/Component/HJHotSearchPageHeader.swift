//
//  HJHotSearchPageHeader.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/29.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit

class HJHotSearchPageHeader: UIView, UISearchBarDelegate {
    
    typealias SearchBarCancelButtonClickedBlock = () -> Swift.Void
    var searchBarCancelButtonClickedBlock: SearchBarCancelButtonClickedBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.addSubview(searchBar)

        changeSearchTextFieldStyle()
        
        
        searchBar.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
        }
        
        layoutIfNeeded()
    }
    
    
    func becomeResponder() {
        searchBar.becomeFirstResponder()
    }
    func resignResponder() {
        searchBar.resignFirstResponder()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    

    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "搜一搜，找到你最想看的内容"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = UIColor.clear
        searchBar.delegate = self
        return searchBar
    }()
    
    
    
    //MARK: - UISearchBarDelegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resignResponder()
//        searchBar.setShowsCancelButton(false, animated: true)
        if let block = searchBarCancelButtonClickedBlock {
            block()
        }

    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        changeCancelButtonStyle()
        return true
    }
    
    
    
    //MARK: - 获取searchBar中的textField进行设置
    func changeSearchTextFieldStyle() {
        for  view  in searchBar.subviews {
            for  subview in view.subviews {
                if subview.isKind(of: UITextField.self) {
                    let textField = subview as! UITextField
                    textField.font = UIFont.systemFont(ofSize: 12)
                    return
                }
            }
        }
    }
    
    func changeCancelButtonStyle() {
        for  view  in searchBar.subviews {
            for  subview in view.subviews {
                if subview.isKind(of: UIButton.self) {
                    let cancelButton = subview as! UIButton
                    cancelButton.setTitleColor(UIColor.black, for: .normal)
                    cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                    cancelButton.setTitle("取消", for: .normal)
                    return
                }
            }
        }
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
}
