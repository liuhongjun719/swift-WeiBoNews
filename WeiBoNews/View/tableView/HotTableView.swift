//
//  HotTableView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/28.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import MJRefresh
import ZFPlayer

class HotTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    //refresh
    typealias HeaderRefreshBlock = () -> Swift.Void
    var headerRefreshBlock: HeaderRefreshBlock!
    
    //load more
    typealias FooterLoadMoreBlock = () -> Swift.Void
    var footerLoadMoreBlock: FooterLoadMoreBlock!
    
    var dataArray = [ModelItem]() //section
    var includesArray = [ModelItem]() //row
    
    
    //创建block变量
    typealias ScrollViewDidScrollOfHomeBlock = (_ isHidden: Bool) -> Swift.Void
    var homeBlock:ScrollViewDidScrollOfHomeBlock!
    
    //区分不同导航中的item对应的界面
    var cate_id: String = ""
    
    
    //点击含有视频的cell执行block
    typealias DidSelectItemAtBlock = (_ modelItem: ModelItem, _ indexPth: IndexPath, _ tableView: UITableView, _ origin_y: CGFloat) -> Swift.Void
    var didSelectItemAtBlock:DidSelectItemAtBlock!
    
    //点击普通的cell执行block
    typealias DidSelectNormalItemAtBlock = (_ modelItem: ModelItem) -> Swift.Void
    var didSelectNormalItemAtBlock:DidSelectNormalItemAtBlock!
    
    
    //player
    var playerView: ZFPlayerView?
    var playerModel: ZFPlayerModel?
    var controlView: HJPlayerControlView?
    
    //点击展开成全屏按钮
    typealias FullScreenBtnDidClickedBlock = (_ modelItem: ModelItem) -> Swift.Void
    var fullScreenBtnDidClickedBlock:FullScreenBtnDidClickedBlock!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        tableView = UITableView.init(frame: frame, style: .grouped)
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight = 0
        tableView.separatorStyle = .none
        self.addSubview(tableView)


        tableView.register(HomeNormalTableCell.self, forCellReuseIdentifier: "HomeNormalTableCell")
        tableView.register(VideosTableCell.self, forCellReuseIdentifier: "VideosTableCell")
        tableView.register(ContainThreeImageCell.self, forCellReuseIdentifier: "ContainThreeImageCell")
        tableView.register(NoImageTableCell.self, forCellReuseIdentifier: "NoImageTableCell")
        
        
        
        
        self.addRefreshHeader()
//        self.addLoadMoreFooter()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


//MARK: - 界面刷新
extension HotTableView {
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
        if let header = tableView.mj_header {
            header.endRefreshing()
        }
        if let footer = tableView.mj_footer {
            footer.endRefreshing()
        }
    }
    
    
    
    
    func reloadPageData() {
        self.tableView.reloadData()
    }
}

//MARK: - Parse model
extension HotTableView {
    public func parseModels(dataItem: DataItem, loadType: String, cate_id: String) {
        dataArray = dataItem.data!
        includesArray = dataItem.included!
        tableView.reloadData()
    }
}

//MARK: - UICollectionView代理方法
extension HotTableView {
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.includesArray.count == 0 {
            return 0
        }
        let modelItem = self.includesArray[indexPath.section*2+indexPath.row].attributes
        if modelItem?.videos?.count != 0 {
            return 250
        }else if ((modelItem?.image_240?.count)! >= 3) {
            return 180
        }else if ((modelItem?.image_240?.count)! == 0) {
            return 80
        }else {
            return 110
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == dataArray.count-1 {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = HJHotSectionView(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        view.modelItem = dataArray[section].attributes
        return view
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == dataArray.count-1 {
            let view = HJHotSectionFooterView(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 50))
            view.backgroundColor = UIColor.white
            return view
        }
        return nil

    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let modelItem = self.includesArray[indexPath.section*2+indexPath.row].attributes
        if modelItem?.videos?.count != 0 {//视频
            let identifier = "VideosTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideosTableCell
            cell.selectionStyle = .none
            cell.changeSepratorColor(index: indexPath.row)
            cell.modelItem = modelItem
            cell.broadcastVideoBlock = {(sender) in
                self.playerView = ZFPlayerView()
                self.playerView?.hasPreviewView = true
                self.playerView?.playerLayerGravity = .resize
                self.playerView?.hasDownload = true
                
                self.controlView = HJPlayerControlView()
                self.playerView?.controlView = self.controlView
                
                self.playerModel = ZFPlayerModel()
                let videoItem = modelItem?.videos?[0]
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
                    self.fullScreenBtnDidClickedBlock(modelItem!)
                }
            }
            return cell
        }else if ((modelItem?.image_240?.count)! >= 3) {
            let identifier = "ContainThreeImageCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ContainThreeImageCell
            cell.selectionStyle = .none
            cell.changeSepratorColor(index: indexPath.row)
            cell.modelItem = modelItem
            return cell
        }else if ((modelItem?.image_240?.count)! == 0) {
            let identifier = "NoImageTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! NoImageTableCell
            cell.selectionStyle = .none
            cell.changeSepratorColor(index: indexPath.row)
            cell.modelItem = modelItem
            return cell
        }
        else {//contain one image on the right
            let identifier = "HomeNormalTableCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! HomeNormalTableCell
            cell.selectionStyle = .none
            cell.changeSepratorColor(index: indexPath.row)
            cell.modelItem = modelItem
            return cell
        }
    }
}


//MARK: - UITableViewDelegate代理方法
extension HotTableView {
    /*
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let modelItem = self.includesArray[indexPath.section*2+indexPath.row].attributes
        if modelItem?.videos?.count != 0 {//视频
            let cellFrameInTableView = tableView.rectForRow(at: indexPath)
            let cellFrameInSuperview = tableView.convert(cellFrameInTableView, to: tableView.superview)
            if let block = didSelectItemAtBlock {
                block(modelItem!, indexPath, tableView, cellFrameInSuperview.origin.y)
            }
        }else {//contain one image on the right
            if let block = didSelectNormalItemAtBlock {
                block(modelItem!)
            }
            
        }
    }
    */
    
}





