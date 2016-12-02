//
//  VideoContainerViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/30.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import Alamofire
import ZFPlayer
import BubbleTransition

class VideoContainerViewController: UIViewController {
    var transition = BubbleTransition()
    var menuInfo: MenuInfo?

    var start: Int = 0
    var count: Int = 11
    var loadType: String = "new"
    var cat_id: String?
    
    var videoTableView: VideoTableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let menu = menuInfo {
            cat_id = menu.id
        }else {
            cat_id = "0"
        }
        
        videoTableView = VideoTableView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height-64))
        self.view.addSubview(videoTableView)
        
        
        //点击展开全屏按钮
        videoTableView.fullScreenBtnDidClickedBlock = {(modelItem) in
            let moviePlayerViewController = MoviePlayerViewController()
            moviePlayerViewController.hidesBottomBarWhenPushed = true
            let videoItem = modelItem.videos?[0]
            moviePlayerViewController.videoUrl = URL(string: (videoItem?.video_url)!)
            self.navigationController?.pushViewController(moviePlayerViewController, animated: false)
        }
        
        
        //点击含有视频的cell
        videoTableView.didSelectItemAtBlock = {(modelItem, indexPath, tableView, origin_y) in
            
            let homeContainerDetailViewController = HomeContainerDetailViewController()
            homeContainerDetailViewController.modelItem = modelItem
            homeContainerDetailViewController.origin_y = origin_y
            homeContainerDetailViewController.isPresent = false
            homeContainerDetailViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(homeContainerDetailViewController, animated: false)

        }
        
        

        
        
        //下拉刷新
        videoTableView.headerRefreshBlock = {() in
            //self.start = 0
            self.loadType = "new"
            self.getData()
        }
        
        //上拉加载
        videoTableView.footerLoadMoreBlock = {() in
            //self.start += 1
            self.loadType = "more"
            self.getData()
        }
        
        //点击tabBar中的热榜时加载最新数据
        NotificationCenter.default.addObserver(self, selector: #selector(VideoContainerViewController.getCurrentDataOfHome), name: NSNotification.Name(rawValue: "VideoRefresh"), object: nil)
        
        
        self.getData()
        
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func getCurrentDataOfHome() {
        self.loadType = "new"
        videoTableView.startRefreshing()
        self.getData()
    }
    
    
    //MARK: - Data
    func getData() {
//        let url = "http://v.top.weibo.cn/2/videos/home_timeline?ac=Wi-Fi&action=videos/home_timeline&aid=01ArM4lGO_arEA3aHnaO0ab012wACGcxrju--D2M52bPX-pBs.&brand=apple&cate_id=2&cur_uid=3948430453&did=0BA4C900-F430-416D-8D85-67045A2E4079&from=7524693017&imei=0BA4C900-F430-416D-8D85-67045A2E4079&ip=192.168.2.10&max_id=1480473014&min_id=1480473014&model=iPhone%206s%20Plus&num=7&sign=832bb7f9d761beac4a2ac1a8be3fb285&time=1480473383&ua=iPhone8%2C2__weiboheadlines__2.4.6__iphone__os9.3.3&vt=3&wm=40011_0001" + String.init(format: "&load=%@", self.loadType)
        let url = "http://v.top.weibo.cn/2/videos/home_timeline?ac=Wi-Fi&action=videos/home_timeline&aid=01ArM4lGO_arEA3aHnaO0ab012wACGcxrju--D2M52bPX-pBs.&brand=apple&cur_uid=3948430453&did=0BA4C900-F430-416D-8D85-67045A2E4079&from=7524693017&imei=0BA4C900-F430-416D-8D85-67045A2E4079&ip=192.168.2.10&max_id=1480473014&min_id=1480473014&model=iPhone%206s%20Plus&time=1480473383&ua=iPhone8%2C2__weiboheadlines__2.4.6__iphone__os9.3.3&vt=3&wm=40011_0001" + String.init(format: "&load=%@", self.loadType) + String.init(format: "&num=%@", (menuInfo?.num)!) + String.init(format: "&sign=%@", (menuInfo?.sign)!) +
            String.init(format: "&cate_id=%@", (menuInfo?.id)!)
        print("url---------:\(url)")
        
        RequestManager.sharedInstance.requestWithUrl(url: url, requestSucceedHandler: { (value) in
            self.videoTableView.endRefreshing()
            print("value______________%@:\(value)")
            self.videoTableView.parseModels(data: value, loadType: self.loadType, cate_id: self.cat_id!)
        }) { (error) in
            self.videoTableView.endRefreshing()
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



