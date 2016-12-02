//
//  HomeContainerDetailViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/24.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import WebKit
import VTMagic
import ObjectMapper

class HomeContainerDetailViewController: VTMagicController {
    
    var modelItem: ModelItem?
    var menuList = [ModelItem]()
    var origin_y: CGFloat?//改变视频的位置
    var isPresent: Bool?//从视频进来为false，从非视频进来为true



    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        self.configMagicView()
        self.configIndicatorView()
        self.addLeftBackButton()
        self.getTopItemData()
        self.getData()
        self.magicView.switch(toPage: 1, animated: false)//停在闪读
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTopItemData() {
        let dic1 = ["name": "原文", "content_oid": "content_oid1"]
        let dic2 = ["name": "闪读", "content_oid": "content_oid2"]
        let item1 = Mapper<ModelItem>().map(JSON: dic1 )
        let item2 = Mapper<ModelItem>().map(JSON: dic2 )
        menuList.append(item1!)
        menuList.append(item2!)
    }
    
    func addLeftBackButton() {
        let leftButton = UIButton()
        leftButton.frame = CGRect.init(x: 0, y: 0, width: 15, height: 15)
        leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        leftButton.setImage(UIImage(named: "wk_navigationbar_back_gray"), for: .normal)
        leftButton.addTarget(self, action: #selector(HomeContainerDetailViewController.popViewController), for: .touchUpInside)
        leftButton.center = self.view.center
        self.magicView.leftNavigatoinItem = leftButton
    }
    

    func configMagicView() {
        self.magicView.itemScale = 1.1
        self.magicView.headerHeight = 40
        self.magicView.navigationHeight = 44
        self.magicView.isAgainstStatusBar = true
        self.magicView.headerView.backgroundColor = UIColor.white
        self.magicView.navigationColor = UIColor.white
        self.magicView.layoutStyle = .default
        self.edgesForExtendedLayout = .all
    }
    
    func configIndicatorView() {
        self.magicView.separatorHeight = 0
        self.magicView.sliderHeight = 0
        self.magicView.sliderColor = UIColor.white
        self.magicView.separatorColor = UIColor.white
        self.magicView.navigationView.clipsToBounds = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.magicView.switch(toPage: 1, animated: false)//停在闪读
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - Action
    func popViewController() {
        if isPresent == true {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController!.popViewController(animated: true)
        }
    }
    
    
    //MARK: - Data
    func getData() {
        let url = "http://v.top.weibo.cn/2/articles/show?ac=Wi-Fi&action=articles/show&aid=01ArM4lGO_arEA3aHnaO0ab012wACGcxrju--D2M52bPX-pBs.&brand=apple&category=5&channel=1&cur_uid=3948430453&did=0BA4C900-F430-416D-8D85-67045A2E4079&from=7524693017&imei=0BA4C900-F430-416D-8D85-67045A2E4079&ip=192.168.2.10&mid=4045318188242722&model=iPhone%206s%20Plus&object_id=1022%3A2309404045318185443574~775098444511445201&puicode=30000087&sign=762687db567e964282640dae904ee495&time=1479968432&token=2.00JINN_E0iJ8i61285997a68MhisdD&type=1&ua=iPhone8%2C2__weiboheadlines__2.4.6__iphone__os9.3.3&uicode=10000289&vt=3&wm=40011_0001"
        //        print("url---------:\(url)")
        
        RequestManager.sharedInstance.requestDetailUrl(url: url, requestSucceedHandler: { (value) in
            self.menuList += value
            self.magicView.reloadData()
            self.magicView.switch(toPage: 1, animated: false)//停在闪读

        }) { (error) in
        }
    }

}


//MARK: - VTMagicViewDataSource
extension HomeContainerDetailViewController {
    override func menuTitles(for magicView: VTMagicView) -> [String] {
        var titleList = [String]()
        for item  in menuList {
            titleList.append(item.name!)
        }
        return titleList
    }
    
    override func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        let item = menuList[Int(itemIndex)]
        let identifier = String.init(format: "itemIdenfifier%d", item.content_oid!)
        var menuItem = magicView.dequeueReusableItem(withIdentifier: identifier)
        if menuItem == nil {
            menuItem = UIButton.init(type: .custom)
            menuItem?.setTitleColor(UIColor.init(red: 115/255.0, green: 113/255.0, blue: 132/255.0, alpha: 1.0), for: .normal)
            menuItem?.setTitleColor(UIColor.init(red: 255/255.0, green: 126/255.0, blue: 28/255.0, alpha: 1.0), for: .selected)

            menuItem?.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
            menuItem?.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            menuItem?.titleLabel?.font = UIFont.init(name: "Helvetica", size: 13)
            
            switch itemIndex {
            case 0://原文
                break
            case 1://闪读
                menuItem?.setImage(UIImage(named: "titlebar_lightning_normal"), for: .normal)
                menuItem?.setImage(UIImage(named: "titlebar_lightning_pressed_yellow"), for: .selected)
                break
            default:
                menuItem?.setImage(UIImage(named: "titlebar_tag_normal"), for: .normal)
                menuItem?.setImage(UIImage(named: "titlebar_tag_pressed_yellow"), for: .selected)
            }
        }
        return menuItem!
    }
    
    
    override func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        let item = menuList[Int(pageIndex)]
        let identifier = String.init(format: "home.identifier%d", item.content_oid!)
        
        if pageIndex < 2 {//webview
            if pageIndex == 0 {//原文:不含有视频
                var homeDetailWebViewController = magicView.dequeueReusablePage(withIdentifier: identifier) as? HomeDetailWebViewController
                if homeDetailWebViewController == nil {
                    homeDetailWebViewController = HomeDetailWebViewController()
                }
                homeDetailWebViewController?.load_url = modelItem?.original_url
                return homeDetailWebViewController!
            }else {//闪读:情形1:界面只含有文章；情形2:界面中上面视频、下面文章；
                if modelItem?.videos?.count == 0{//进入只含有文章的界面
                    var homeDetailWebViewController = magicView.dequeueReusablePage(withIdentifier: identifier) as? HomeDetailWebViewController
                    if homeDetailWebViewController == nil {
                        homeDetailWebViewController = HomeDetailWebViewController()
                    }
                    homeDetailWebViewController?.load_url = modelItem?.article_url
                    return homeDetailWebViewController!
                }else {//进入含有视频和文章的界面
                    var videoBroadcastViewController = magicView.dequeueReusablePage(withIdentifier: identifier) as? VideoBroadcastViewController
                    if videoBroadcastViewController == nil {
                        videoBroadcastViewController = VideoBroadcastViewController()
                    }

                    videoBroadcastViewController?.modelItem = modelItem
                    videoBroadcastViewController?.origin_y = origin_y
                    return videoBroadcastViewController!

                }
            }
            
        }else {//tableview：非 原文 和 闪读
            var homeContainerViewController = magicView.dequeueReusablePage(withIdentifier: identifier) as? HomeContainerViewController
            if homeContainerViewController == nil {
                homeContainerViewController = HomeContainerViewController()
            }
            return homeContainerViewController!
        }
 
    }
}

//MARK: - VTMagicViewDelegate
extension HomeContainerDetailViewController {
    override func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt) {
    }
    
    override func magicView(_ magicView: VTMagicView, viewDidDisappear viewController: UIViewController, atPage pageIndex: UInt) {
    }
    
    override func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt) {
    }
    override func magicView(_ magicView: VTMagicView, sliderWidthAt itemIndex: UInt) -> CGFloat {
        return 0
    }
}


