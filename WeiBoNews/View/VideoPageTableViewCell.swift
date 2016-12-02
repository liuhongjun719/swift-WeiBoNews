//
//  VideoPageTableViewCell.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/30.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import SnapKit
import ZFPlayer
class VideoPageTableViewCell: UITableViewCell {

    
    //player
    var playerView: ZFPlayerView?
    var playerModel: ZFPlayerModel?
    var controlView: HJPlayerControlView?
    
    var modelItem: ModelItem?
    var indexPath: IndexPath?
    var tableView: UITableView?
    
    //点击展开成全屏按钮
    typealias FullScreenBtnDidClickedBlock = (_ modelItem: ModelItem) -> Swift.Void
    var fullScreenBtnDidClickedBlock:FullScreenBtnDidClickedBlock!
    
    
    func refreshVideoCell(modelItem: ModelItem, indexPath: IndexPath, tableView: UITableView) {
        self.modelItem = modelItem
        self.indexPath = indexPath
        self.tableView = tableView
        
        let titleText = modelItem.title
        let sourceText = modelItem.source
        var praiseText = String.init(format: "%d", modelItem.likes_count!)
        if praiseText == "0" {
            praiseText = ""
        }
        let plays_count_text = String.init(format: "%d", modelItem.plays_count!)
        
        title.text = titleText
        source.text = sourceText
        praiseLabel.text = praiseText
        plays_count.text = modelItem.plays_count?.getBroadcastString()
        
        let videoItem = modelItem.videos?[0]
        videoImage.sd_setImage(with: URL.init(string: (videoItem?.img_url)!))
        
        
        
        
        let titleSize = titleText?.getStringSizeWithWidth(fontSize: 16, width: self.frame.size.width-20)
        let sourceSize = sourceText?.getStringSizeWithWidth(fontSize: 10, width: source.frame.size.width)
        let praiseSize = praiseText.getStringSizeWithWidth(fontSize: 10, width: praiseLabel.frame.size.width)
        let plays_count_size = plays_count_text.getStringSizeWithWidth(fontSize: 12, width: plays_count.frame.size.width)
        
        
        videoImage.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(180)
        }
        
        
        broadcast.snp.makeConstraints { (make) in
            make.center.equalTo(videoImage)
            make.width.height.equalTo(40)
        }
        
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(videoImage.snp.bottom).offset(5)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.height.equalTo((titleSize?.height)!).priority(700)
        }
        
        
        source.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.left.equalTo(title)
            make.height.equalTo(15)
            make.width.equalTo((sourceSize?.width)!).priority(600)
        }
        
        plays_count.snp.makeConstraints { (make) in
            make.left.equalTo(source.snp.right).offset(5)
            make.centerY.equalTo(source)
            make.height.equalTo(source)
            make.width.equalTo(plays_count_size.width).priority(600)
        }
        
        separatorLine.snp.makeConstraints { (make) in
            make.left.equalTo(videoImage)
            make.right.equalTo(videoImage)
            make.top.equalTo(source.snp.bottom).offset(10)
            make.height.equalTo(5)
        }
        
        praiseLabel.snp.makeConstraints { (make) in
            make.right.equalTo(title)
            make.centerY.equalTo(source).offset(3)
            make.height.equalTo(source)
            make.width.equalTo(praiseSize.width).priority(600)
        }
        
        praiseImage.snp.makeConstraints { (make) in
            make.right.equalTo(praiseLabel.snp.left).offset(-3)
            make.centerY.equalTo(source)
            make.width.height.equalTo(15)
        }
        
        share.snp.makeConstraints { (make) in
            make.right.equalTo(praiseImage.snp.left).offset(-20)
            make.centerY.equalTo(source)
            make.width.height.equalTo(15)
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
        self.addSubview(share)
        self.addSubview(praiseImage)
        self.addSubview(praiseLabel)
        self.addSubview(plays_count)
        videoImage.addGestureRecognizer(tapVideoImageGesture)
        layoutIfNeeded()
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
        title.numberOfLines = 2
        title.font = UIFont.systemFont(ofSize: 16)
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
        source.font = UIFont.systemFont(ofSize: 10)
        return source
    }()
    
    lazy var separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
        return separatorLine
    }()
    
    
    lazy var broadcast: UIButton = {
        let broadcast = UIButton()
        broadcast.setBackgroundImage(UIImage(named: "video_play"), for: .normal)
        broadcast.addTarget(self, action: #selector(VideoPageTableViewCell.broadcastVideo), for: .touchUpInside)
        return broadcast
    }()
    
    
    lazy var share: UIButton = {
       let share = UIButton()
       share.setBackgroundImage(UIImage(named:"feed_article_share"), for: .normal)

        return share
    }()
    
    lazy var praiseImage: UIButton = {
       let praiseImage = UIButton()
        praiseImage.setBackgroundImage(UIImage(named:"feed_article_like"), for: .normal)
        praiseImage.setBackgroundImage(UIImage(named:"feed_article_like_pressed"), for: .selected)
        return praiseImage
    }()
    
    lazy var praiseLabel: UILabel = {
        let praiseLabel = UILabel()
        praiseLabel.textColor = UIColor.init(red: 211/255.0, green: 210/255.0, blue: 211/255.0, alpha: 1.0)
        praiseLabel.font = UIFont.systemFont(ofSize: 10)
        return praiseLabel
    }()
    
    lazy var plays_count: UILabel = {
       let plays_count = UILabel()
        plays_count.textColor = UIColor.init(red: 157/255.0, green: 165/255.0, blue: 178/255.0, alpha: 1.0)
        plays_count.font = UIFont.systemFont(ofSize: 12)
        return plays_count
    }()
    
    
    lazy var tapVideoImageGesture: UITapGestureRecognizer = {
        let tapVideoImageGesture = UITapGestureRecognizer.init(target: self, action: #selector(VideoPageTableViewCell.tapVideoImage))
        return tapVideoImageGesture
    }()
    
    
 
    
    
    //MARK: - Action
    //点击播放按钮使视频播放
    func broadcastVideo(sender: UIButton) {
        tapVideoImage()
    }
    
    //点击videoImage使视频播放
    func tapVideoImage() {
        self.playerView = ZFPlayerView()
        self.playerView?.hasPreviewView = true
        self.playerView?.playerLayerGravity = .resize
        self.playerView?.hasDownload = true
        
        self.controlView = HJPlayerControlView()
        self.playerView?.controlView = self.controlView
        
        self.playerModel = ZFPlayerModel()
        
        self.playerView?.playerModel = self.playerModel
        self.playerView?.addPlayer(toCellImageView: self.videoImage)
        //settting video
        self.playerModel?.indexPath = indexPath
        self.playerModel?.cellImageViewTag = (indexPath?.row)!
        
        let videoItem = modelItem?.videos?[0]
        self.playerModel?.placeholderImageURLString = videoItem?.img_url
        self.playerModel?.videoURL = URL(string: (videoItem?.video_url)!)
        self.playerModel?.tableView = tableView
        self.playerView?.autoPlayTheVideo()
        
        //点击屏幕展开按钮
        self.controlView?.fullScreenBtnDidClickedBlock = {(button) in
            if let block = self.fullScreenBtnDidClickedBlock {
                block(self.modelItem!)
            }
        }
    }
}

