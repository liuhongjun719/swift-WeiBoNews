//
//  MoviePlayerViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/15.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import MediaPlayer
import ZFPlayer
import SnapKit
class MoviePlayerViewController: UIViewController, HJPlayerDelegate {
    
    var videoUrl: URL?
    var playerView: HJFullScreenPlayerView!
    var playerModel: ZFPlayerModel!
    var controlView: HJFullScreenPlayerControlView!
    var sourceFrame: NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView = HJFullScreenPlayerView()
        playerView.delegate = self
        playerView.hasPreviewView = true
        playerView.playerLayerGravity = .resize
        self.view.addSubview(playerView)
        
        print("frames----------%@:\(sourceFrame)")



        
        
        let playerModel = ZFPlayerModel()
        playerModel.title = "这里是标题"
        playerModel.videoURL = self.videoUrl
        //        playerModel.placeholderImageURLString = ""
        playerView.playerModel = playerModel
        
        
        controlView = HJFullScreenPlayerControlView()
        playerView.controlView = controlView

        controlView.fullScreenBtnDidClickedBlock = {(button) in
            self.navigationController!.popViewController(animated: false)
        }
        
        playerView.autoPlayTheVideo()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        playerView.setNeedsUpdateConstraints()
        playerView.updateConstraintsIfNeeded()
        UIView.animate(withDuration: 0, animations: {
            self.playerView.snp.updateConstraints { (make) in
                make.top.bottom.leading.trailing.equalTo(self.view)
            }
        }) { (finish) in
            self.playerView.layoutIfNeeded()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SwitchToHomeItem"), object: nil)
        playerView.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - ZFPlayerDelegate
    func hj_playerBackAction() {
        self.navigationController!.popViewController(animated: false)
    }
    
    
    //MARK: - Screen orientation
//    override var shouldAutorotate: Bool {
//        return ZFBrightnessView.shared().isLockScreen
//    }
//    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .allButUpsideDown
//    }
//    
//    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
//        return .portrait
//    }
    





}
