//
//  VideosTableCell.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/14.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit
import ZFPlayer
class VideosTableCell: UITableViewCell {
    
    
    typealias BroadcastVideoBlock = () -> Swift.Void
    var broadcastVideoBlock: BroadcastVideoBlock!
    
    var modelItem: ModelItem! {
        didSet {
            title.text = modelItem.title
            source.text = modelItem.source
            
            if modelItem.images_count != nil && modelItem.images_count! > 0 {
                videoImage.sd_setImage(with: URL(string: (modelItem.image_240?[0].des_url!)!), placeholderImage: nil)
            }
            
        }
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.white
        self.addSubview(title)
        self.addSubview(videoImage)
        self.addSubview(source)
        self.addSubview(separatorLine)
        videoImage.addSubview(broadcast)
        videoImage.addGestureRecognizer(tapVideoImageGesture)
      
        title.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(20)
        }
        
        videoImage.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.right.equalTo(title)
            make.height.equalTo(180)
        }
        
        
        broadcast.snp.makeConstraints { (make) in
            make.center.equalTo(videoImage)
            make.width.height.equalTo(40)
        }
        
        
        source.snp.makeConstraints { (make) in
            make.top.equalTo(videoImage.snp.bottom).offset(10)
            make.left.equalTo(videoImage)
            make.height.equalTo(15)
        }
        
        separatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(videoImage)
            make.right.equalTo(videoImage)
            make.bottom.equalTo(self)
            make.height.equalTo(0.8)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 改变热榜界面的分割线颜色
    func changeSepratorColor(index:Int) {
        if index % 2 != 0 {
            separatorLine.backgroundColor = UIColor.white
        }else {
            separatorLine.backgroundColor = UIColor.init(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)
            
        }
    }
    

    
    
    
    //MARK: - UI
    lazy var title: UILabel = {
        let title = UILabel()
        title.textColor = UIColor.init(red: 30/255.0, green: 45/255.0, blue: 62/255.0, alpha: 1.0)
        title.numberOfLines = 1
        return title
    }()
    
    lazy var videoImage: UIImageView = {
        let videoImage = UIImageView()
        videoImage.isUserInteractionEnabled = true
        videoImage.tag = 101
        return videoImage
    }()
    
    lazy var source: UILabel = {
        let source = UILabel()
        source.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        source.font = UIFont.systemFont(ofSize: 12)
        return source
    }()
    
    lazy var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.init(red: 226/255.0, green: 226/255.0, blue: 226/255.0, alpha: 1.0)
        return separatorLine
    }()
    
    
    lazy var broadcast: UIButton = {
        let broadcast = UIButton()
        broadcast.setBackgroundImage(UIImage(named: "video_play"), for: .normal)
        broadcast.addTarget(self, action: #selector(VideosTableCell.broadcastVideo), for: .touchUpInside)
        return broadcast
    }()
    
    
    lazy var playerView: ZFPlayerView =  {
        let playerView = ZFPlayerView()
        return playerView
    }()
    
    lazy var tapVideoImageGesture: UITapGestureRecognizer = {
        let tapVideoImageGesture = UITapGestureRecognizer.init(target: self, action: #selector(VideosTableCell.tapVideoImage))
        return tapVideoImageGesture
    }()
    
    
    
    //MARK: - Action
    func broadcastVideo(sender: UIButton) {
        if let block = broadcastVideoBlock {
            block()
        }
    }
    //点击videoImage使视频播放
    func tapVideoImage() {
        if let block = broadcastVideoBlock {
            block()
        }
    }
}
