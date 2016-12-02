//
//  VideoTableView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/30.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import MJRefresh

class VideoTableView: UIView, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    
    //refresh
    typealias HeaderRefreshBlock = () -> Swift.Void
    var headerRefreshBlock: HeaderRefreshBlock!
    
    //load more
    typealias FooterLoadMoreBlock = () -> Swift.Void
    var footerLoadMoreBlock: FooterLoadMoreBlock!
    
    var dataArray = [ModelItem]() //加载数据
    
  
    
    
    var cate_id: String = ""//区分不同导航中的item对应的界面
    
    
    //点击含有视频的cell执行block
    typealias DidSelectItemAtBlock = (_ modelItem: ModelItem, _ indexPth: IndexPath, _ tableView: UITableView, _ origin_y: CGFloat) -> Swift.Void
    var didSelectItemAtBlock:DidSelectItemAtBlock!
    
    
    
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
        

        
        
        tableView.register(VideoPageTableViewCell.self, forCellReuseIdentifier: "VideoPageTableViewCell")

        self.addRefreshHeader()
        self.addLoadMoreFooter()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
}




//MARK: - 界面刷新
extension VideoTableView {
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
extension VideoTableView {
    public func parseModels(data: [ModelItem], loadType: String, cate_id: String) {
        
        if cate_id == self.cate_id {//同一个界面
            if loadType == "new"  {
                self.dataArray.removeAll()
                self.dataArray = data
            }else {
                self.dataArray += data
            }
            
        }else {//不同界面
            self.dataArray.removeAll()
            self.dataArray = data
        }
        self.cate_id = cate_id
        tableView.reloadData()
        
    }
}

//MARK: - UICollectionView代理方法
extension VideoTableView {
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.dataArray.count == 0 {
            return 0
        }
        let modelItem = self.dataArray[indexPath.row]
        let titleSize = modelItem.title?.getStringSizeWithWidth(fontSize: 16, width: self.frame.size.width-20)
        if Double((titleSize?.height)!) < 20.0 {            return 245.0
        }

        return 265.0
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    @objc(tableView:cellForRowAtIndexPath:) func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let modelItem = self.modelArray[indexPath.row]
        let modelItem = self.dataArray[indexPath.row]
        let identifier = "VideoPageTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! VideoPageTableViewCell
        cell.selectionStyle = .none
        cell.refreshVideoCell(modelItem: modelItem, indexPath: indexPath, tableView: tableView)
    
        cell.fullScreenBtnDidClickedBlock = {(modelItem) in
            if let block = self.fullScreenBtnDidClickedBlock {
                block(modelItem)
            }
        }
        return cell
    }
}


//MARK: - UITableViewDelegate代理方法
extension VideoTableView {
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellFrameInTableView = tableView.rectForRow(at: indexPath)
        let cellFrameInSuperview = tableView.convert(cellFrameInTableView, to: tableView.superview)
        let modelItem = self.dataArray[indexPath.row]
        if let block = didSelectItemAtBlock {
            block(modelItem, indexPath, tableView, cellFrameInSuperview.origin.y)
        }
    }
}




















