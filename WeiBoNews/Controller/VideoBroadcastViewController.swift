//
//  VideoBroadcastViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/30.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import MediaPlayer
import ZFPlayer
import SnapKit
import SDWebImage
import WebKit

class VideoBroadcastViewController: UIViewController, HJPlayerDelegate {
    
//    var playerView: HJFullScreenPlayerView!
//    var playerModel: ZFPlayerModel!
//    var controlView: HJFullScreenPlayerControlView!
    var modelItem: ModelItem?
    var origin_y: CGFloat?
    
    
    //player
    var playerView: ZFPlayerView!
    var playerModel: ZFPlayerModel!
    var controlView: HJPlayerControlView!
    
    lazy var videoImage: UIImageView = {
        let videoImage = UIImageView()
        let videoItem = self.modelItem?.videos?[0]
        videoImage.frame = self.playerView.bounds
        videoImage.sd_setImage(with: URL.init(string: (videoItem?.img_url)!))
        return videoImage
    }()
    
    lazy var broadcastImage: UIImageView = {
        let broadcastImage = UIImageView()
        broadcastImage.frame = CGRect.init(x: (self.playerView.frame.size.width-40)/2, y: (self.playerView.frame.size.height-40)/2, width: 40, height: 40)
        broadcastImage.image = UIImage(named: "video_play")
        return broadcastImage
    }()
    
    lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.frame = CGRect.init(x: self.playerView.frame.origin.x, y: 180, width: self.playerView.frame.size.width, height: self.view.frame.size.height-self.playerView.frame.size.height)
        webView.load(URLRequest.init(url: URL.init(string: (self.modelItem?.article_url)!)!))
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        let videoItem = modelItem?.videos?[0]

        playerView = ZFPlayerView()
        self.playerView.frame = CGRect.init(x: 0, y: origin_y!, width: self.view.frame.size.width, height: 180)

        playerView.hasPreviewView = true
        playerView.playerLayerGravity = .resize
        self.view.addSubview(playerView)
 
        
        playerView.addSubview(videoImage)
        playerView.addSubview(broadcastImage)

        let playerModel = ZFPlayerModel()
        playerModel.title = "这里是标题"
        playerModel.videoURL = URL(string: (videoItem?.video_url)!)
        playerModel.placeholderImageURLString = videoItem?.img_url
        playerView.playerModel = playerModel
        
        
        controlView = HJPlayerControlView()
        playerView.controlView = controlView
        
        //进入全屏视频播放界面
        controlView.fullScreenBtnDidClickedBlock = {(button) in
            let moviePlayerViewController = MoviePlayerViewController()
            moviePlayerViewController.hidesBottomBarWhenPushed = true
            moviePlayerViewController.videoUrl = URL(string: (videoItem?.video_url)!)
            self.navigationController?.pushViewController(moviePlayerViewController, animated: false)
        }

        animateToTop()
  
    }
    
 
    
    func animateToTop() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { 
            self.playerView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 180)
            }) { (finish) in
                self.videoImage.removeFromSuperview()
                self.broadcastImage.removeFromSuperview()
                self.view.addSubview(self.webView)
                self.playerView.autoPlayTheVideo()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerView.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
