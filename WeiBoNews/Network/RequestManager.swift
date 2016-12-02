//
//  RequestManager.swift
//  SwiftSouthWeekend
//
//  Created by 123456 on 16/11/4.
//  Copyright © 2016年 123456. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ObjectMapper
import AlamofireObjectMapper

open class RequestManager {
    
    typealias RequestSucceedHandler = (_ responseSucceedObject: [ModelItem]) -> Void
    typealias RequestErrorHandler = (_ responseError: Error) -> Void
    
    //热榜
    typealias RequestHotSucceedHandler = (_ requestHotSucceedHandler: DataItem) -> Void

    

    class var sharedInstance :RequestManager {
        struct Singleton {
            static let instance = RequestManager()
        }
        return Singleton.instance
    }
    
    
    func requestWithUrl(url: String, requestSucceedHandler: @escaping RequestSucceedHandler, requestErrorHandler: @escaping RequestErrorHandler) {
        /*
        Alamofire.request(url).validate().responseArray { (response: DataResponse<[ModelItem]>) in
            switch response.result {
            case .success(let value):
                requestSucceedHandler(value)
                print("succeed-------------")
            case .failure(let error):
                requestErrorHandler(error)
                print("error-------------:\(error)")
            }
        }
        */
        

        
        Alamofire.request(url).validate().responseObject { (response: DataResponse<DataItem>) in
            let dataItem = response.result.value
            
//            print("responseeeee-------------%@:\(dataItem?.data?.count)")
            switch response.result {
            case .success(_):
                requestSucceedHandler((dataItem?.data)!)
                print("succeed-------------")
            case .failure(let error):
                requestErrorHandler(error)
                print("error-------------:\(error)")
            }
            
        }
    }
    
    //针对home的详情界面
    func requestDetailUrl(url: String, requestSucceedHandler: @escaping RequestSucceedHandler, requestErrorHandler: @escaping RequestErrorHandler) {
        Alamofire.request(url).validate().responseObject(keyPath: "data")   { (response: DataResponse<DetailTitleItem>) in
            let dataItem = response.result.value
            
            print("responseeeee-------------%@:\(dataItem?.tags?.count)")
            switch response.result {
            case .success(_):
                requestSucceedHandler((dataItem?.tags)!)
                print("succeed-------------")
            case .failure(let error):
                requestErrorHandler(error)
                print("error-------------:\(error)")
            }
            
        }
    }
    
    
    //针对"热榜"界面
    func requestHotPageUrl(url: String, requestSucceedHandler: @escaping RequestHotSucceedHandler, requestErrorHandler: @escaping RequestErrorHandler) {
        Alamofire.request(url).validate().responseObject { (response: DataResponse<DataItem>) in
            let dataItem = response.result.value
            
            print("item============\(dataItem)")
            print("responseeeee-------------:\(dataItem?.data?.count)===\(dataItem?.included?.count)")
            switch response.result {
            case .success(_):
                requestSucceedHandler(dataItem!)
                print("succeed-------------")
            case .failure(let error):
                requestErrorHandler(error)
                print("error-------------:\(error)")
            }
            
        }
    }
    
    
    
}







