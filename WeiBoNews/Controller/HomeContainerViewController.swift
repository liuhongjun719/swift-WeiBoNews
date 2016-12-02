//
//  HomeContainerViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/11.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import Alamofire
import ZFPlayer
import BubbleTransition

class HomeContainerViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var transition = BubbleTransition()

    var homeTabView: HomeTableView!
    var start: Int = 0
    var count: Int = 11
    var loadType: String = "new"
    var menuInfo: MenuInfo?
    var cat_id: String?
    
    var selectedIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let parameters: Parameters = [
//            "foo": [1,2,3],
//            "bar": [
//                "baz": "qux"
//            ]
//        ]
//        // Both calls are equivalent
//        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
//            print("Executing response handler on utility queue-----\(response)")
//        }
        


        if let menu = menuInfo {
            cat_id = menu.id
        }else {
            cat_id = "0"
        }

        homeTabView = HomeTableView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64))
        self.view.addSubview(homeTabView)
        
        //界面的偏移量超过一定距离时，改变tabBarItem的图片为刷新图片
        homeTabView.scrollViewDidScrollBlock = {(offset) in
            let tabBarItem = self.tabBarController?.tabBar.items?[0]
            if offset > 200 {//刷新图标
                tabBarItem?.image = UIImage(named: "tab_icon_home_refresh_pressed")
                tabBarItem?.selectedImage = UIImage(named:"tab_icon_home_refresh_pressed")
            }else {//原图标
                tabBarItem?.image = UIImage(named: "tab_icon_home_normal")
                tabBarItem?.selectedImage = UIImage(named: "tab_icon_home_pressed")
            }
        }
        
        //screen
        homeTabView.fullScreenBtnDidClickedBlock = {(modelItem) in
            let moviePlayerViewController = MoviePlayerViewController()
            moviePlayerViewController.hidesBottomBarWhenPushed = true
            let videoItem = modelItem.videos?[0]
            moviePlayerViewController.videoUrl = URL(string: (videoItem?.video_url)!)
            self.navigationController?.pushViewController(moviePlayerViewController, animated: false)
        }
        
        
        //点击"含有"视频的cell
        homeTabView.didSelectItemAtBlock = {(modelItem, indexPath, tableView, origin_y) in
            let homeContainerDetailViewController = HomeContainerDetailViewController()
            homeContainerDetailViewController.modelItem = modelItem
            homeContainerDetailViewController.origin_y = origin_y
            homeContainerDetailViewController.isPresent = false
            homeContainerDetailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeContainerDetailViewController, animated: false)
        }
        
        
        //点击"不含有"视频的cell
        homeTabView.didSelectNormalItemAtBlock = {(modelItem) in
            let homeContainerDetailViewController = HomeContainerDetailViewController()
            homeContainerDetailViewController.modelItem = modelItem
            homeContainerDetailViewController.isPresent = true
            homeContainerDetailViewController.hidesBottomBarWhenPushed = true
            homeContainerDetailViewController.transitioningDelegate = self
            homeContainerDetailViewController.modalPresentationStyle = .custom
            self.present(homeContainerDetailViewController, animated: true, completion: nil)
        }
        
        
        //下拉刷新
        homeTabView.headerRefreshBlock = {() in
            //self.start = 0
            self.loadType = "new"
            self.getData()
        }
        
        //上拉加载
        homeTabView.footerLoadMoreBlock = {() in
            //self.start += 1
            self.loadType = "more"
            self.getData()
        }
        
        
        //点击tabBar中的首页时加载最新数据
        NotificationCenter.default.addObserver(self, selector: #selector(HomeContainerViewController.getCurrentDataOfHome), name: NSNotification.Name(rawValue: "HomeRefresh"), object: nil)
        
        self.getData()

    }
    
    

    
    func getCurrentDataOfHome() {
        self.loadType = "new"
        homeTabView.startRefreshing()
        self.getData()
    }
    
    
    //MARK: - Data
    func getData() {
        let url = String.init(format: "http://v.top.weibo.cn/2/articles/home_timeline?ac=Wi-Fi&action=articles/home_timeline&aid=01AmuMbftq8FUZQM350FyL2ZQDPv6UM9fHZKyHJEAo5z4ViJo.&brand=apple&cate_id=%@", cat_id!) +
            String.init(format: "&did=0BA4C900-F430-416D-8D85-67045A2E4079&from=7524693017&imei=0BA4C900-F430-416D-8D85-67045A2E4079&ip=192.168.2.10&load=%@", loadType) + "&max_id=1478842224&min_id=1478831438&model=iPhone%206s%20Plus&num=33&sign=37cca7faa79e9922bf5d82f249d1a3a4&time=1478842225&ua=iPhone8%2C2__weiboheadlines__2.4.6__iphone__os9.3.3&vt=3&wm=40011_0001"
        print("url---------:\(url)")
        
        RequestManager.sharedInstance.requestWithUrl(url: url, requestSucceedHandler: { (value) in
            self.homeTabView.endRefreshing()
            print("value______________%@:\(value)")
            self.homeTabView.parseModels(data: value, loadType: self.loadType, cate_id: self.cat_id!)
            //self.homeTabView.parseModels(data: value, start: self.start, className: NSStringFromClass(HomeContainerViewController.self).components(separatedBy: ".").last!)
        }) { (error) in
            self.homeTabView.endRefreshing()
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
extension HomeContainerViewController {
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



