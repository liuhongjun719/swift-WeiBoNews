//
//  HJTopBarView.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/17.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class HJTopBarView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    typealias DismissControllerBlock = () -> Swift.Void
    var dismissControllerBlock: DismissControllerBlock?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("HJTopBarView", owner: self, options: nil)
        self.contentView.frame = self.bounds
        self.addSubview(self.contentView)
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @IBAction func closeCategoryAction(_ sender: AnyObject) {
        if let block = dismissControllerBlock {
            block()
        }
    }

    
}
