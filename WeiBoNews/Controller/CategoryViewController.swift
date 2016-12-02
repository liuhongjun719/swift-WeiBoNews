//
//  CategoryViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/16.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    var topBarView: HJTopBarView!
    var menuList = [MenuInfo]()
    var categoryCollectionView: CategoryCollectionView!
    var currentPageIndex: UInt = 0

    
    typealias SwitchToSelectedItemBlock = (_ index: Int) -> Swift.Void
    var switchToSelectedItemBlock: SwitchToSelectedItemBlock?
    
    //关闭界面时
    typealias RefreshTopItemBlock = (_ index: Int) -> Swift.Void
    var refreshTopItemBlock: RefreshTopItemBlock?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Nav
        topBarView = HJTopBarView()
        topBarView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 64)
        self.view.addSubview(topBarView)

        topBarView.dismissControllerBlock = {() in
            self.dismiss(animated: true, completion: nil)
        }
        
        
        //content
        categoryCollectionView = CategoryCollectionView(frame: CGRect.init(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height-64))
        self.view.addSubview(categoryCollectionView)
        

        
        
        //点击不可编辑cell，首页移动到该item
        categoryCollectionView.didSelectItemAtBlock = {(menuInfo, index) in
            if let block = self.switchToSelectedItemBlock {
                block(index)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CategoryItemDidClicked"), object: index)
            }
        }
        
        //点击可编辑cell: cell分为已选中 和 未选中 的情况
        //删除"未选中"的cell：首页的pageIndex为 currentPageIndex
        //删除"已选中"的cell：首页的pageIndex为 0
        categoryCollectionView.didSelectEditItemAtBlock = {(modelArray, index, currentIndex) in
            self.menuList = modelArray

            if index == Int(self.currentPageIndex) {//已选中
                self.categoryCollectionView.currentPageIndex = 0
                self.currentPageIndex = UInt(currentIndex)
                //删除当前选中的cell时，把当前被选中的cell变为第一个cell
                if let block = self.switchToSelectedItemBlock {
                    block(0)
                }
            }else {//未选中
                self.categoryCollectionView.currentPageIndex = index
                //删除未选中的cell时，currentPageIndex
                if let block = self.switchToSelectedItemBlock {
                    block(Int(currentIndex))
                }
            }
        }
        
        
        //交换cell时执行,如果被交换的cell中含有当前被选中的cell，需要改变currentPageIndex
        categoryCollectionView.itemDidExchangedBlock = {(modelArray, currentIndex) in
            self.menuList = modelArray
            self.currentPageIndex = UInt(currentIndex)
            self.homeTopItemCached.eraseTable()
            self.homeTopItemCached.insertItems(items: self.menuList)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CategoryItemDidChanged"), object: self.currentPageIndex)
        }
        
    
        
        self.initializeCategoryData()
    }
    
    lazy var homeTopItemCached: HomeTopItemCached = {
        let homeTopItemCached = HomeTopItemCached()
        homeTopItemCached.createTable()
        return homeTopItemCached
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.25, delay: 0.1, options: .curveEaseIn, animations: {
            self.topBarView.closeBtn.transform = self.topBarView.closeBtn.transform.rotated(by: CGFloat(-M_PI_4))
            
        }) { (finish) in
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.topBarView.closeBtn.transform = self.topBarView.closeBtn.transform.rotated(by: CGFloat(M_PI_4))
            
        }) { (finish) in
        }
        
        //调整顺序后重新缓存,并通知首页更新
        homeTopItemCached.eraseTable()
        homeTopItemCached.insertItems(items: self.menuList)
        
        if let block = refreshTopItemBlock {
            block(Int(currentPageIndex))
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
 
    
    //MARK: - Data
    func initializeCategoryData() {
        menuList = homeTopItemCached.readItems()
        categoryCollectionView.parseModels(data: menuList, index: currentPageIndex)
    }
    
    

}
