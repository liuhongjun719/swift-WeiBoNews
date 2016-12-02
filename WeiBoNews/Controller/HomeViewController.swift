
//
//  HomeViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/11.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import VTMagic
import BubbleTransition

class HomeViewController: VTMagicController, UIViewControllerTransitioningDelegate {
    
    var menuList = [MenuInfo]()
    var transition = BubbleTransition()
    var pageIndex: UInt = 0 //记录当前屏幕上的界面所对应的index

    
    //MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configMagicView()
        self.addComponent()
        self.configIndicatorView()
        self.getTopItemData()
        self.magicView.switch(toPage: 0, animated: true)

        
        //监听topItem的顺序和数量是否发生了变化
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.categoryItemDidChanged), name: NSNotification.Name(rawValue: "CategoryItemDidChanged"), object: nil)
        
        //监听cell被点击
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.categoryCellDidClicked), name: NSNotification.Name(rawValue: "CategoryItemDidClicked"), object: nil)
        
        //视频播放界面返回时，滚动到指定的界面
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.switchToHomeItemAfterVideoPagePop), name: NSNotification.Name(rawValue: "SwitchToHomeItem"), object: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func getTopItemData() {
        if homeTopItemCached.count() >= 3 {//从缓存中读取
            self.menuList = homeTopItemCached.readItems()
        }else {//从plist文件中读取
            self.initializeHeaderViewData()
        }
        self.magicView.reloadData()
    }
    
    lazy var homeTopItemCached: HomeTopItemCached = {
        let homeTopItemCached = HomeTopItemCached()
        homeTopItemCached.createTable()
        return homeTopItemCached
    }()
    
    func addComponent() {
    let rightButton = UIButton()
        rightButton.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        rightButton.setImage(UIImage(named: "feed_titlebar_add"), for: .normal)
        rightButton.addTarget(self, action: #selector(HomeViewController.showCategoryController), for: .touchUpInside)
        rightButton.center = self.view.center
        self.magicView.rightNavigatoinItem = rightButton
    }
    
    func configMagicView() {
        self.magicView.itemScale = 1.2
        self.magicView.headerHeight = 40
        self.magicView.navigationHeight = 44
        self.magicView.isAgainstStatusBar = true
        self.magicView.headerView.backgroundColor = UIColor.white
        self.magicView.navigationColor = UIColor.white
        self.magicView.layoutStyle = .default
        self.edgesForExtendedLayout = .all
    }
    func configIndicatorView() {
        self.magicView.separatorHeight = 1
        self.magicView.sliderColor = UIColor.init(red: 255/255.0, green: 126/255.0, blue: 28/255.0, alpha: 1.0)
        self.magicView.separatorColor = UIColor.white
        self.magicView.navigationView.clipsToBounds = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Notification
    func categoryItemDidChanged(noti: Notification) {
        pageIndex = noti.object as!UInt
        self.menuList = homeTopItemCached.readItems()
        self.magicView.switch(toPage: pageIndex, animated: true)
        self.magicView.reloadData()
    }
    
    func categoryCellDidClicked(noti: Notification) {
        pageIndex = noti.object as!UInt
        self.magicView.switch(toPage: pageIndex, animated: true)
    }
    
    func switchToHomeItemAfterVideoPagePop(noti: Notification) {
        print("page---------------\(pageIndex)")
        self.magicView.switch(toPage: pageIndex, animated: true)
    }
    
    
    //MARK: - Data
    func initializeHeaderViewData() {
        let path = Bundle.main.path(forResource:"catalogDefault", ofType: "plist")
        let category = NSArray.init(contentsOfFile: path!)
        var menuInfoList = [MenuInfo]()

        
        for i in 0 ..< category!.count {
            let item = category?[i]
            let menuItem = MenuInfo()
            menuItem.id = ((item as! NSDictionary).object(forKey: "id") as! String?)!
            menuItem.subscribe = 0
//            menuItem.subscribe = ((item as! NSDictionary).object(forKey: "subscribe") as! Int32?)!
            menuItem.type = ((item as! NSDictionary).object(forKey: "type") as! String?)!
            menuItem.name = ((item as! NSDictionary).object(forKey: "name") as! String?)!
            menuItem.uicode = ((item as! NSDictionary).object(forKey: "uicode") as! String?)!
            menuInfoList.append(menuItem)
        }

        self.menuList = menuInfoList
        homeTopItemCached.insertItems(items: self.menuList)
    }

    
    //MARK: - Action
    func showCategoryController() {
        let categoryViewController = CategoryViewController()
        categoryViewController.transitioningDelegate = self
        categoryViewController.modalPresentationStyle = .custom
        categoryViewController.currentPageIndex = self.pageIndex
        self.present(categoryViewController, animated: true, completion: nil)
        
        categoryViewController.refreshTopItemBlock = {(index) in
            self.menuList = self.homeTopItemCached.readItems()
            self.magicView.reloadData()
        }
        categoryViewController.switchToSelectedItemBlock = {(index) in
            print("index--------\(index)")
            self.pageIndex = UInt(index)
                self.magicView.switch(toPage: UInt(index), animated: true)
        }
    }

}


//MARK: - VTMagicViewDataSource
extension HomeViewController {
    override func menuTitles(for magicView: VTMagicView) -> [String] {
        var titleList = [String]()
        for item  in menuList {
            titleList.append(item.name)
        }
        return titleList
    }
    
    override func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        let item = menuList[Int(itemIndex)]
        let identifier = String.init(format: "itemIdenfifier%d", item.id)
        var menuItem = magicView.dequeueReusableItem(withIdentifier: identifier)
        if menuItem == nil {
            menuItem = UIButton.init(type: .custom)
            menuItem?.setTitleColor(UIColor.init(red: 115/255.0, green: 113/255.0, blue: 132/255.0, alpha: 1.0), for: .normal)
            menuItem?.setTitleColor(UIColor.init(red: 255/255.0, green: 126/255.0, blue: 28/255.0, alpha: 1.0), for: .selected)
            menuItem?.titleLabel?.font = UIFont.init(name: "Helvetica", size: 13)
        }
        return menuItem!
    }
    
    
    override func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let item = menuList[Int(pageIndex)]
        let identifier = String.init(format: "home.identifier%d", item.id)
        var homeContainerViewController = magicView.dequeueReusablePage(withIdentifier: identifier) as? HomeContainerViewController
        
        if homeContainerViewController == nil {
            homeContainerViewController = HomeContainerViewController()
        }
        
        homeContainerViewController?.menuInfo = menuList[Int(pageIndex)]
        return homeContainerViewController!
    }
}

//MARK: - VTMagicViewDelegate
extension HomeViewController {
    override func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt) {
        self.pageIndex = pageIndex
        
    }
    
    override func magicView(_ magicView: VTMagicView, viewDidDisappear viewController: UIViewController, atPage pageIndex: UInt) {
    }
    
    override func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt) {
        print("didSelectItemAt-------\(pageIndex)")
        pageIndex = itemIndex
    }
    
    override func magicView(_ magicView: VTMagicView, sliderWidthAt itemIndex: UInt) -> CGFloat {
        return 0
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension HomeViewController {
    @objc(animationControllerForPresentedController:presentingController:sourceController:) func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = (self.magicView.rightNavigatoinItem?.center)!
        transition.bubbleColor = UIColor.white
        transition.duration = 0.25
        return transition
    }
    
    
    @objc(animationControllerForDismissedController:) func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = (self.magicView.rightNavigatoinItem?.center)!
        transition.bubbleColor = UIColor.white
        transition.duration = 0.5
        return transition
    }
}


