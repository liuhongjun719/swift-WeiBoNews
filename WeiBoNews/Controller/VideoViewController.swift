//
//  VideoViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/11.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit


import VTMagic
import BubbleTransition

class VideoViewController: VTMagicController, UIViewControllerTransitioningDelegate {
    
    var menuList = [MenuInfo]()
    var transition = BubbleTransition()
    var pageIndex: UInt = 0 //记录当前屏幕上的界面所对应的index
    
    
    //MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.configMagicView()
        self.configIndicatorView()
        self.getTopItemData()
        self.magicView.switch(toPage: 0, animated: true)
        
        
        //视频播放界面返回时，滚动到指定的界面
//        NotificationCenter.default.addObserver(self, selector: #selector(VideoViewController.switchToHomeItemAfterVideoPagePop), name: NSNotification.Name(rawValue: "SwitchToHomeItem"), object: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getTopItemData() {
        self.initializeHeaderViewData()
        self.magicView.reloadData()
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
//    func switchToHomeItemAfterVideoPagePop(noti: Notification) {
//        print("page---------------\(pageIndex)")
//        self.magicView.switch(toPage: pageIndex, animated: true)
//    }
    
    
    //MARK: - Data
    func initializeHeaderViewData() {
        let path = Bundle.main.path(forResource:"VideoDefaultList", ofType: "plist")
        let category = NSArray.init(contentsOfFile: path!)
        var menuInfoList = [MenuInfo]()
        
        
        for i in 0 ..< category!.count {
            let item = category?[i]
            let menuItem = MenuInfo()
            menuItem.id = ((item as! NSDictionary).object(forKey: "id") as! String?)!
            menuItem.subscribe = 0
            menuItem.name = ((item as! NSDictionary).object(forKey: "name") as! String?)!
            menuItem.sign = ((item as! NSDictionary).object(forKey: "sign") as! String?)!
            menuItem.num = ((item as! NSDictionary).object(forKey: "num") as! String?)!
            menuInfoList.append(menuItem)
        }
        
        self.menuList = menuInfoList
    }
    
}


//MARK: - VTMagicViewDataSource
extension VideoViewController {
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
        var videoContainerViewController = magicView.dequeueReusablePage(withIdentifier: identifier) as? VideoContainerViewController
        
        if videoContainerViewController == nil {
            videoContainerViewController = VideoContainerViewController()
        }
        
        videoContainerViewController?.menuInfo = menuList[Int(pageIndex)]
        return videoContainerViewController!
    }
}

//MARK: - VTMagicViewDelegate
extension VideoViewController {
    override func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt) {
        
        
    }
    
    override func magicView(_ magicView: VTMagicView, viewDidDisappear viewController: UIViewController, atPage pageIndex: UInt) {
    }
    
    override func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt) {
        print("didSelectItemAt-------\(pageIndex)")
    }
    
    override func magicView(_ magicView: VTMagicView, sliderWidthAt itemIndex: UInt) -> CGFloat {
        return 0
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension VideoViewController {
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



