//
//  HomeTableView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/14.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import MJRefresh
import ZFPlayer
//import HJPlayerControlView
//import Masonry
//import ZFVideoModel
class HomeTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    //refresh
    typealias HeaderRefreshBlock = () -> Swift.Void
    var headerRefreshBlock: HeaderRefreshBlock!
    
    //load more
    typealias FooterLoadMoreBlock = () -> Swift.Void
    var footerLoadMoreBlock: FooterLoadMoreBlock!
    
    //滚动视图滚动到一定位置时，改变item的图片
    typealias ScrollViewDidScrollBlock = (_ offset: CGFloat) -> Swift.Void
    var scrollViewDidScrollBlock: ScrollViewDidScrollBlock!

    
    //创建block变量
    typealias ScrollViewDidScrollOfHomeBlock = (_ isHidden: Bool) -> Swift.Void
    var homeBlock:ScrollViewDidScrollOfHomeBlock!
    
    
    //
    var modelArray = [ModelItem]()
    var cate_id: String = ""//区分不同导航中的item对应的界面
    
    
    //点击含有视频的cell执行block
    typealias DidSelectItemAtBlock = (_ modelItem: ModelItem, _ indexPth: IndexPath, _ tableView: UITableView, _ origin_y: CGFloat) -> Swift.Void
    var didSelectItemAtBlock:DidSelectItemAtBlock!
    
    //点击普通的cell执行block
    typealias DidSelectNormalItemAtBlock = (_ modelItem: ModelItem) -> Swift.Void
    var didSelectNormalItemAtBlock:DidSelectNormalItemAtBlock!
    
    
    //player
    var playerView: ZFPlayerView?
    var playerModel: ZFPlayerModel?
//    var controlView: ZFPlayerControlView?
    var controlView: HJPlayerControlView?
    
    //点击展开成全屏按钮
    typealias FullScreenBtnDidClickedBlock = (_ modelItem: ModelItem) -> Swift.Void
    var fullScreenBtnDidClickedBlock:FullScreenBtnDidClickedBlock!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        tableView = UITableView.init(frame: frame, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.addSubview(tableView)
        
        tableView.register(HomeNormalTableCell.self, forCellReuseIdentifier: "HomeNormalTableCell")
        tableView.register(VideosTableCell.self, forCellReuseIdentifier: "VideosTableCell")
        tableView.register(ContainThreeImageCell.self, forCellReuseIdentifier: "ContainThreeImageCell")
        tableView.register(NoImageTableCell.self, forCellReuseIdentifier: "NoImageTableCell")

        
        
        
        self.addRefreshHeader()
        self.addLoadMoreFooter()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

  
}


    
    
   
 





//MARK: - 界面刷新
extension HomeTableView {
    func addRefreshHeader() {
        let header = MJRefreshStateHeader.init {
            self.headerRefresh()
        }
        // 隐藏时间
        header?.lastUpdatedTimeLabel.isHidden = false;
        // 隐藏状态
        header?.stateLabel.isHidden = false;
        // 马上进入刷新状态
//                header?.beginRefreshing()
        // 设置header
        self.tableView.mj_header = header
    }
    
    
    
    func addLoadMoreFooter() {
        let footer = MJRefreshAutoNormalFooter.init {
            self.footerLoadMore()
        }
        self.tableView.mj_footer = footer
    }
    
    func headerRefresh() {
        self.headerRefreshBlock()
    }
    
    func footerLoadMore() {
        self.footerLoadMoreBlock()
        
    }
    
    func startRefreshing() {
        self.tableView.mj_header.beginRefreshing()
    }
    
    func endRefreshing() {
        tableView.mj_header.endRefreshing()
        tableView.mj_footer.endRefreshing()
    }
    
    
    
    
    func reloadPageData() {
        self.tableView.reloadData()
    }
}

//MARK: - Parse model
extension HomeTableView {
    public func parseModels(data: [ModelItem], loadType: String, cate_id: String) {
        
        if cate_id == self.cate_id {//同一个界面
            if loadType == "new"  {
                self.modelArray.removeAll()
                self.modelArray = data
            }else {
                self.modelArray += data
            }
            
        }else {//不同界面
            self.modelArray.removeAll()
            self.modelArray = data
        }
        self.cate_id = cate_id
        tableView.reloadData()
 
        
        

        
//        if loadType == "new" {
//            self.modelArray.removeAll()
//            self.modelArray = data
//        }else {
//            self.modelArray += data
//        }
//        tableView.reloadData()
//        
        
    }
}

//MARK: - UITableViewDataSource代理方法
extension HomeTableView {
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let modelItem = self.modelArray[indexPath.row]
        if modelItem.videos?.count != 0 {
            return 250
        }else if (modelItem.images_count == 3) {
            return 180
        }else if (modelItem.images_count == 0) {
            return 80
        }else {
            return 110
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelArray.count
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let modelItem = self.modelArray[indexPath.row]
        
        if modelItem.videos?.count != 0 {//视频
            let identifier = "VideosTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideosTableCell
            cell.selectionStyle = .none
            cell.modelItem = self.modelArray[indexPath.row]
            cell.broadcastVideoBlock = {() in
                self.playerView = ZFPlayerView()
                self.playerView?.hasPreviewView = true
                self.playerView?.playerLayerGravity = .resize
                self.playerView?.hasDownload = true

//                self.playerView?.delegate = self
                self.controlView = HJPlayerControlView()
                self.playerView?.controlView = self.controlView
                
                self.playerModel = ZFPlayerModel()
                let videoItem = modelItem.videos?[0]
                self.playerModel?.videoURL = URL(string: (videoItem?.video_url)!)
                
                self.playerModel?.placeholderImageURLString = videoItem?.img_url
                self.playerModel?.tableView = self.tableView
                self.playerModel?.indexPath = indexPath
                self.playerModel?.cellImageViewTag = cell.videoImage.tag
                self.playerView?.playerModel = self.playerModel
                self.playerView?.addPlayer(toCellImageView: cell.videoImage)
                self.playerView?.autoPlayTheVideo()
                
                
                //点击屏幕展开按钮
                self.controlView?.fullScreenBtnDidClickedBlock = {(button) in
                    self.fullScreenBtnDidClickedBlock(self.modelArray[indexPath.row])
                }
            }
            return cell
        }else if (modelItem.images_count == 3) {
            let identifier = "ContainThreeImageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ContainThreeImageCell
            cell.selectionStyle = .none
            cell.modelItem = self.modelArray[indexPath.row]
            return cell
        }else if (modelItem.images_count == 0) {
            let identifier = "NoImageTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NoImageTableCell
            cell.selectionStyle = .none
            cell.modelItem = self.modelArray[indexPath.row]
            return cell
        }
        else {//contain one image on the right
            let identifier = "HomeNormalTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeNormalTableCell
            cell.selectionStyle = .none
            cell.modelItem = self.modelArray[indexPath.row]
            return cell
        }
        
        
        
    }
    

}


//MARK: - UITableViewDelegate代理方法
extension HomeTableView {
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellFrameInTableView = tableView.rectForRow(at: indexPath)
        let cellFrameInSuperview = tableView.convert(cellFrameInTableView, to: tableView.superview)
        let modelItem = self.modelArray[indexPath.row]
        if modelItem.videos?.count != 0 {//视频
            if let block = didSelectItemAtBlock {
                block(self.modelArray[indexPath.row], indexPath, tableView, cellFrameInSuperview.origin.y)
            }
        }else {//contain one image on the right
            if let block = didSelectNormalItemAtBlock {
                block(self.modelArray[indexPath.row])
            }
        }
        

    }
}


extension HomeTableView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        guard tableView.mj_header.state != .refreshing else {
            return
        }
        if let block = scrollViewDidScrollBlock {
            block(scrollView.contentOffset.y)
        }
    }


}































