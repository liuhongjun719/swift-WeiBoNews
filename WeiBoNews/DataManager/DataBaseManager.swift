//
//  DataBaseManager.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/22.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit

class DataBaseManager: NSObject {
    var dataBase: FMDatabase?
    var docName: String?
    
    class var sharedInstance :DataBaseManager {
        struct Singleton {
            static let instance = DataBaseManager()
        }
        return Singleton.instance
    }
    
    override init() {
        super.init()
        initializeDBWithName(name: "account.db")
    }
    
    
    func initializeDBWithName(name: String) {
        if name.isEmpty {
            return
        }
        
//        guard (dataBase?.open())! else {
//            print("Unable to open database")
//            return
//        }
        
        let document = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        docName = String.init(format: "%@/%@", document, name) 
        print("数据库路径：%@", docName)
        
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: docName!)
        self.connect()
        if exist == false {
            print("数据库已经存在")
        }else {
            print("数据库不存在")
        }
    }
    
    func connect() {
        if dataBase == nil {
            dataBase = FMDatabase.init(path: docName)
        }
//        dataBase?.shouldCacheStatements() = true
//        dataBase?.open()
        if dataBase?.open() == false {
            print("不能打开数据库")
        }else {
            print("可以打开数据库")
        }

    }

}



//Optional("/Users/a123456/Library/Developer/CoreSimulator/Devices/FCE9F433-0084-4C23-980F-06E5F4F51258/data/Containers/Data/Application/CF105E2C-85FE-46F4-8FF1-2E2086B36C26/Documents/account.db")
