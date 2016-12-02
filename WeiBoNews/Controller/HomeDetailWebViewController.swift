//
//  HomeDetailWebViewController.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/24.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit
import WebKit
class HomeDetailWebViewController: UIViewController {
    var webView: WKWebView!
    var load_url: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        webView.load(URLRequest.init(url: URL.init(string: load_url!)!))
        self.view.addSubview(webView)

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
