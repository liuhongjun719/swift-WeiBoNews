//
//  HotViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/11.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import Alamofire
import ZFPlayer
import BubbleTransition

class HotViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var transition = BubbleTransition()
    
    var hotTabView: HotTableView!
    var start: Int = 0
    var count: Int = 11
    var loadType: String = "new"
    var menuInfo: MenuInfo?
    var cat_id: String?
    
    var hotSearchHeader: HJHotSearchHeader!
    
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let menu = menuInfo {
            cat_id = menu.id
        }else {
            cat_id = "0"
        }
        
        hotTabView = HotTableView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(hotTabView)
        

        //screen
        hotTabView.fullScreenBtnDidClickedBlock = {(modelItem) in
            let moviePlayerViewController = MoviePlayerViewController()
            moviePlayerViewController.hidesBottomBarWhenPushed = true
            let videoItem = modelItem.videos?[0]
            moviePlayerViewController.videoUrl = URL(string: (videoItem?.video_url)!)
            self.navigationController?.pushViewController(moviePlayerViewController, animated: false)
        }
        
        
        //点击含有视频的cell
        hotTabView.didSelectItemAtBlock = {(modelItem, indexPath, tableView, origin_y) in
            let homeContainerDetailViewController = HomeContainerDetailViewController()
            homeContainerDetailViewController.modelItem = modelItem
            homeContainerDetailViewController.origin_y = origin_y
            homeContainerDetailViewController.isPresent = false
            homeContainerDetailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeContainerDetailViewController, animated: false)
        }
        
        
        //点击不含有视频的cell
        hotTabView.didSelectNormalItemAtBlock = {(modelItem) in
            let homeContainerDetailViewController = HomeContainerDetailViewController()
            homeContainerDetailViewController.modelItem = modelItem
            homeContainerDetailViewController.isPresent = true
            homeContainerDetailViewController.hidesBottomBarWhenPushed = true
            homeContainerDetailViewController.transitioningDelegate = self
            homeContainerDetailViewController.modalPresentationStyle = .custom
            self.present(homeContainerDetailViewController, animated: true, completion: nil)
            
        }
        
        
        //下拉刷新
        hotTabView.headerRefreshBlock = {() in
            //self.start = 0
            self.loadType = "new"
            self.getData()
        }
        
        //点击tabBar中的热榜时加载最新数据
        NotificationCenter.default.addObserver(self, selector: #selector(HotViewController.getCurrentDataOfHome), name: NSNotification.Name(rawValue: "HotRefresh"), object: nil)
        
     

        self.getData()
        
    }
    
    func addCustomNav() {
        self.navigationController?.navigationItem.leftBarButtonItem = nil
        hotSearchHeader = HJHotSearchHeader()
        hotSearchHeader.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        //点击搜索，进入搜索界面
        hotSearchHeader.searchHeaderDidClickedBlock = {() in
            let hotSearchViewController = HotSearchViewController()
            hotSearchViewController.hidesBottomBarWhenPushed = true
            hotSearchViewController.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(hotSearchViewController, animated: false)
        }
        self.navigationController?.navigationBar.addSubview(hotSearchHeader)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        addCustomNav()

    }
    
    
    
    func getCurrentDataOfHome() {
        self.loadType = "new"
        hotTabView.startRefreshing()
        self.getData()
    }
    
    
    //MARK: - Data
    func getData() {
        let url = "http://v.top.weibo.cn/2/hotlist?ac=Wi-Fi&aid=01AmuMbftq8FUZQM350FyL2ZQDPv6UM9fHZKyHJEAo5z4ViJo.&brand=apple&did=0BA4C900-F430-416D-8D85-67045A2E4079&from=7524693017&imei=0BA4C900-F430-416D-8D85-67045A2E4079&ip=192.168.2.10&model=iPhone%206s%20Plus&sign=8bd5662de2c4b147b543c755a886b6cd&time=1478842468&ua=iPhone8%2C2__weiboheadlines__2.4.6__iphone__os9.3.3&vt=3&wm=40011_0001"
        print("url---------:\(url)")
        
        RequestManager.sharedInstance.requestHotPageUrl(url: url, requestSucceedHandler: { (value) in
            self.hotTabView.endRefreshing()
            print("value______________%@:\(value)")
            self.hotTabView.parseModels(dataItem: value, loadType: self.loadType, cate_id: self.cat_id!)
        }) { (error) in
            self.hotTabView.endRefreshing()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Screen orientation
    override var shouldAutorotate: Bool {
        return ZFBrightnessView.shared().isLockScreen
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

}

//MARK: - UIViewControllerTransitioningDelegate
extension HotViewController {
    @objc(animationControllerForPresentedController:presentingController:sourceController:) func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = (self.view.window?.center)!
        transition.bubbleColor = UIColor.white
        transition.duration = 0.25
        return transition
    }
    
    
    @objc(animationControllerForDismissedController:) func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = (self.view.window?.center)!
        transition.bubbleColor = UIColor.white
        transition.duration = 0.25
        return transition
    }
}

