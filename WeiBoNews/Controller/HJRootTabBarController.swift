//
//  HJRootTabBarController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/11.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class HJRootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //homeViewController
        let homeViewController = HomeViewController()
        let homeNav = UINavigationController.init(rootViewController: homeViewController)
        homeNav.isNavigationBarHidden = true
        homeNav.tabBarItem = creatTabBarItemWithTitle(title: "首页", image: "tab_icon_home_normal", selectedImage: "tab_icon_home_pressed")
        
        
        //hotViewController
        let hotViewController = HotViewController()
        let hotNav = UINavigationController.init(rootViewController: hotViewController)
        hotNav.isNavigationBarHidden = true
        hotNav.tabBarItem = creatTabBarItemWithTitle(title: "热榜", image: "tab_icon_discovery_normal", selectedImage: "tab_icon_discovery_pressed")
        

        
        //videoViewController
        let videoViewController = VideoViewController()
        let videoNav = UINavigationController.init(rootViewController: videoViewController)
        videoNav.isNavigationBarHidden = true
        videoNav.tabBarItem = creatTabBarItemWithTitle(title: "视频", image: "tab_icon_video_normal", selectedImage: "tab_icon_video_pressed")
        

        //myViewController
        let myViewController = MyViewController()
        let myNav = UINavigationController.init(rootViewController: myViewController)
        myNav.isNavigationBarHidden = true
        myNav.tabBarItem =
            creatTabBarItemWithTitle(title: "我的", image: "tab_icon_mine_normal", selectedImage: "tab_icon_mine_pressed")
        
        
        self.viewControllers = [homeNav, hotNav, videoNav, myNav]
        UITabBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().alpha = 1
        UITabBar.appearance().tintAdjustmentMode = .normal
        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = UIColor.black

        } else {
            // Fallback on earlier versions
        }

    }
    
    func creatTabBarItemWithTitle(title: String, image: String, selectedImage: String) -> UITabBarItem {
        let item = UITabBarItem.init(title: title, image: UIImage(named: image), selectedImage: UIImage(named: selectedImage))
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 255/255.0, green: 126/255.0, blue: 28/255.0, alpha: 1.0)] , for: .selected)
        item.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.init(red: 162/255.0, green: 163/255.0, blue: 165/255.0, alpha: 1.0)] , for: .normal)
        return item
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        self.selectedIndex = (self.tabBar.items?.index(of: item))!
        //当“首页”的item处于选中状态时，并且再点击的情况下要刷新界面
        if self.selectedIndex == 0 && (self.tabBar.items?.index(of: item))! == 0 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HomeRefresh"), object: nil)
        }else if self.selectedIndex == 1 && (self.tabBar.items?.index(of: item))! == 1 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HotRefresh"), object: nil)
        }else if self.selectedIndex == 2 && (self.tabBar.items?.index(of: item))! == 2 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "VideoRefresh"), object: nil)
        }

    }
    



}
