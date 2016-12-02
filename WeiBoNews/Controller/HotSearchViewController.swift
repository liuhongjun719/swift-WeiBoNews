//
//  HotSearchViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/29.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class HotSearchViewController: UIViewController {

    var hotSearchPageHeader: HJHotSearchPageHeader!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        addCustomNav()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hotSearchPageHeader.becomeResponder()
    }
    
    func addCustomNav() {
        let view_on_nav = self.navigationController?.navigationBar.viewWithTag(100)
        view_on_nav?.removeFromSuperview()
        hotSearchPageHeader = HJHotSearchPageHeader()
        hotSearchPageHeader.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
        self.navigationController?.navigationBar.addSubview(hotSearchPageHeader)
        
        hotSearchPageHeader.searchBarCancelButtonClickedBlock = {() in
            self.navigationController!.popViewController(animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
