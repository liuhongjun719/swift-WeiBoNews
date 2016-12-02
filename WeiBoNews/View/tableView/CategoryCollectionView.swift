//
//  CategoryCollectionView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/16.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import MJRefresh

class CategoryCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView! = nil

    var modelArray = [MenuInfo]()
    var addModelArray = [MenuInfo]()
    var isEdit: Bool = false //判断cell是否可以进行操作
    var selectedIndexPath: IndexPath?
    var currentPageIndex: Int?
    
    
    //点击不可编辑的cell时执行block, 进入首页
    typealias DidSelectItemAtBlock = (_ menuInfo: MenuInfo, _ index: Int) -> Swift.Void
    var didSelectItemAtBlock:DidSelectItemAtBlock!
    
    //点击可编辑的cell时执行block, 删除item
    typealias DidSelectEditItemAtBlock = (_ items: [MenuInfo], _ index: Int, _ currentIndex: Int) -> Swift.Void
    var didSelectEditItemAtBlock:DidSelectEditItemAtBlock!
    
    
    //交换cell的位置
    typealias ItemDidExchangedBlock = (_ items: [MenuInfo], _ currentIndex:Int) -> Swift.Void
    var itemDidExchangedBlock:ItemDidExchangedBlock!
    
    lazy var homeTopItemCached: HomeTopItemCached = {
        let homeTopItemCached = HomeTopItemCached()
        homeTopItemCached.createTable()
        return homeTopItemCached
    }()
    
    lazy var willAddItemCached: HomeWillAddItemCached = {
        let willAddItemCached = HomeWillAddItemCached()
        willAddItemCached.createTable()
        return willAddItemCached
    }()
    
    
    //MARK: - UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout();
        layout.scrollDirection = .vertical;
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: CGRect.init(x: frame.origin.x+10, y: 0, width: frame.size.width-20, height: frame.size.height), collectionViewLayout: layout);
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self;
        collectionView.dataSource = self;
        self.addSubview(collectionView)
        
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.register(MyCategoryChannelView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier:"Header")
        collectionView.register(SubscribeChannelView.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier:"SubscribeHeader")

        

        
        //add longpressGesture
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(CategoryCollectionView.longPressCollectionView))
        longPressGesture.minimumPressDuration = 0.25
        collectionView.addGestureRecognizer(longPressGesture)

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Gesture of moving the cell
    func longPressCollectionView(gesture: UILongPressGestureRecognizer) {
        guard isEdit == true else {
            return
        }
        

        let selectedCell: CategoryCell?
        switch gesture.state {
        case .began:
            let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView))
            self.selectedIndexPath = selectedIndexPath
            
//            self.isEdit = true//长按后也变成可编辑
//            collectionView.reloadData()
//            collectionView.performBatchUpdates({
//                self.collectionView.reloadItems(at: [selectedIndexPath!])
//                }, completion: { (finish) in
//            })
            

            selectedCell = collectionView.cellForItem(at: selectedIndexPath!) as! CategoryCell?


            selectedCell?.transform = (selectedCell?.transform)!.scaledBy(x: 1.5 ,y: 1.5)

            UIView.animate(withDuration: 0.25, animations: {
                selectedCell?.transform = CGAffineTransform.identity
            })
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath!)
            break
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
            break
        case .ended:
            selectedCell = collectionView.cellForItem(at: self.selectedIndexPath!) as! CategoryCell?
            selectedCell?.transform = CGAffineTransform.identity
            collectionView.endInteractiveMovement()
            break
        default:
            selectedCell = collectionView.cellForItem(at: self.selectedIndexPath!) as! CategoryCell?
            selectedCell?.transform = CGAffineTransform.identity
            collectionView.cancelInteractiveMovement()
            
        }
    }
}

//MARK: - Parse model
extension CategoryCollectionView {
    public func parseModels(data: [MenuInfo], index: UInt) {
        self.modelArray = data
        self.addModelArray = willAddItemCached.readItems()
        self.currentPageIndex = Int(index)
        collectionView.reloadData()
    }
}



//MARK: - UICollectionView代理方法
extension CategoryCollectionView {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.modelArray.count
        }
        return self.addModelArray.count
    }
    
    @objc(numberOfSectionsInCollectionView:) func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let modelItem = self.modelArray[indexPath.row]
        let identifier = "CategoryCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! CategoryCell

        if indexPath.section == 0 {
            cell.reloadCell(item: modelArray[indexPath.row], isEdit: isEdit, currentPageIndex: currentPageIndex!, cellIndex: indexPath.item)
            
            //        cell.isEdit = self.isEdit
            //        if indexPath.item < 3 {
            //            cell.isEdit = false
            //        }
            //        cell.menuInfo = self.modelArray[indexPath.row]
            
        }else {
            cell.reloadCellWithSubscripeChannel(item: addModelArray[indexPath.row])
        }
        
        return cell

    }
    
    
    
    @objc(collectionView:layout:sizeForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let modelItem = self.modelArray[indexPath.row]
        return CGSize(width: (self.frame.size.width-80)/4, height: 30)
    }
    
    
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {//我的频道
            if isEdit == true {//当cell为 “可编辑” 时，点击cell为删除该cell
                let item = modelArray[indexPath.item]
                modelArray.remove(at: indexPath.item)
                homeTopItemCached.deleteItem(item: item)
                if indexPath.item < currentPageIndex!{
                    currentPageIndex! -= 1
                }else {
                }
                
                if let block = didSelectEditItemAtBlock {
                    block(modelArray, indexPath.item, currentPageIndex!)
                }
                addModelArray.append(item)
                willAddItemCached.insertItem(item: item)
                collectionView.reloadData()
                
            }else {//当cell为 “不可编辑” 状态时，点击cell会选中当前cell对应的页面，并返回上一个界面
                if let block = didSelectItemAtBlock {
                    block(self.modelArray[indexPath.row], indexPath.item)
                }
            }
        }else {//订阅频道
            let item = addModelArray[indexPath.item]
            
            addModelArray.remove(at: indexPath.item)
            willAddItemCached.deleteItem(item: item)
            
            modelArray.append(item)
            homeTopItemCached.insertItem(item: item)
            
            collectionView.reloadData()
        }
    }
    
    @objc(collectionView:canMoveItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    @objc(collectionView:moveItemAtIndexPath:toIndexPath:) func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let menuInfo = modelArray[sourceIndexPath.item]
        modelArray.remove(at: sourceIndexPath.item)
        modelArray.insert(menuInfo, at: destinationIndexPath.item)
        //拖动cell时要改变被选中cell的index
        if sourceIndexPath.item == currentPageIndex {
            currentPageIndex = destinationIndexPath.item
            print("destinationIndexPath=======\(currentPageIndex)")
        }else if destinationIndexPath.item == currentPageIndex {
            currentPageIndex = sourceIndexPath.item
            print("sourceIndexPath=======\(currentPageIndex)")
        }
  
        itemDidExchangedBlock(modelArray, currentPageIndex!)

    }
    
    
    @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:) func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var resuableView: UICollectionReusableView?
        if kind == "UICollectionElementKindSectionHeader"  {
            if indexPath.section == 0 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader" , withReuseIdentifier: "Header", for: indexPath) as? MyCategoryChannelView
                //改变cell的可编辑状态
                view?.editBtnDidClickBlock = {(isEdit) in
                    print("-------------%d:\(isEdit)")
                    self.isEdit = isEdit
                    collectionView.reloadData()
                }
                resuableView = view
            }else if indexPath.section == 1 {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: "UICollectionElementKindSectionHeader" , withReuseIdentifier: "SubscribeHeader", for: indexPath) as? SubscribeChannelView
                resuableView = view
            }
        }
        return resuableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: UIScreen.main.bounds.size.width, height: 40)
        }else {
            return CGSize.init(width: UIScreen.main.bounds.size.width, height: 40)
        }
    }
 
    
}

