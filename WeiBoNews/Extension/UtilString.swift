//
//  UtilString.swift
//  SwiftSouthWeekend
//
//  Created by 123456 on 16/10/24.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

extension NSString {
    
//    //获取字符串高度
//    func getStringSizeWithWidth(fontSize:CGFloat,width:CGFloat) -> CGSize {
//        let statusLabelText: NSString = self as NSString
//        let size = CGSize.init(width: width, height: 900)
//        let dic = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSFontAttributeName as NSCopying)
//        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
//        return strSize
//    }
    
    func getStringSize(fontSize:CGFloat,height:CGFloat) -> CGSize {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: 1000, height: height)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize
    }

    
}

extension String {
    //获取字符串高度
    func getStringSizeWithWidth(fontSize:CGFloat,width:CGFloat) -> CGSize {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: width, height: 900)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize
    }
    
    func getStringSize(fontSize:CGFloat,height:CGFloat) -> CGSize {
        let statusLabelText: NSString = self as NSString
        let size = CGSize.init(width: 1000, height: height)
        let dic = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSFontAttributeName as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context: nil).size
        return strSize
    }
}


extension Int {
    //热榜界面每个模块的访问量（例：145.2万）
    func getAttributeString() -> (String, NSMutableAttributedString) {
        var heatText = NSString.init(format: "%d", self)
        var attributeString = NSMutableAttributedString()
        if heatText.length < 5  {
            heatText = String(self) as NSString
            let attributeString_less = NSMutableAttributedString.init(string: heatText as String)
            attributeString_less.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], range: NSRange.init(location: 0, length: heatText.length))
            attributeString = attributeString_less
            
        }else if heatText.length >= 5 {
            heatText = String.init(format: "%.1f万", Float(self)/10000) as NSString
            let attributeString_great = NSMutableAttributedString.init(string: heatText as String)
            
            attributeString_great.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], range: NSRange.init(location: 0, length: heatText.length))
            
            attributeString_great.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 10)], range: NSRange.init(location: heatText.length-1, length: 1))
            attributeString = attributeString_great
        }
        return (heatText as String, attributeString)

    }
    
    //视频界面的播放次数
    func getBroadcastString() -> String {
        var playCountString = NSString.init(format: "%d", self)
        if playCountString == "0" {
            playCountString = ""
        }else if playCountString.length < 5  {
            playCountString = NSString.init(format: "%d次播放", self)
        }else if playCountString.length >= 5 {
            playCountString = String.init(format: "%.0f万次播放", Float(self)/10000) as NSString
        }
        return playCountString as String
    }
}
