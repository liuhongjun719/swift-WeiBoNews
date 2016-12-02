//
//  HomeTopItemCached.swift
//  WeiBoNews
//
//  Created by 123456 on 16/11/22.
//  Copyright © 2016年 123456. All rights reserved.
//

import UIKit


class HomeTopItemCached: NSObject {
    var db: FMDatabase?
    var tableName: String = "HomeItemTable"

    override init() {
        db = DataBaseManager.sharedInstance.dataBase
    }
    
    
    func createTable() {
         let sql = "CREATE TABLE IF NOT EXISTS HomeItemTable (id VARCHAR(2048) PRIMARY KEY, subscribe INTEGER, type VARCHAR(64) DEFAULT NULL, name TEXT, uicode VARCHAR(64))"
        
        do {
            try db!.executeUpdate(sql, values: nil)
        }catch {
            print("failed=====: \(error.localizedDescription)")
        }
 
//        if try db?.executeUpdate(sql, values: nil) == true {
//            print("建表成功")
//        }else {
//            print("建表失败")
//        }
    }
    
    func deleteItem(item: MenuInfo) {
        let query = String.init(format: "DELETE FROM HomeItemTable WHERE id = '%@'", item.id)
        
        do {
            try db?.executeQuery(query, values: nil)
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }
    }
    
    
    func readItems() -> [MenuInfo] {
        let query = "SELECT * FROM HomeItemTable"
//        let rs = db?.executeQuery(query) as! FMResultSet
        var array = [MenuInfo]()

        do {
           let rs = try db!.executeQuery(query, values: nil)
            while rs.next() {
                let item = MenuInfo()
                item.id = rs.string(forColumn: "id")
                item.subscribe = rs.int(forColumn: "subscribe")
                item.type = rs.string(forColumn: "type")
                item.name = rs.string(forColumn: "name")
                item.uicode = rs.string(forColumn: "uicode")
                array.append(item)
            }
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }
        return array
    }
    
    func insertItems(items: [MenuInfo]) {
        db?.beginTransaction()
        for item in items {
            self.insertItem(item: item)
        }
        
        db?.commit()
        
    }
    
    func insertItem(item: MenuInfo) {
        if self.existItem(item: item) {
            return
        }
        let sql = "INSERT INTO HomeItemTable (id,subscribe,type,name,uicode) VALUES (?,?,?,?,?)"
        do {
            try db?.executeUpdate(sql, values: [item.id, item.subscribe, item.type, item.name, item.uicode])
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }

    }
    
    func count() -> Int {
        let sql = "SELECT COUNT(*) FROM HomeItemTable"
        do {
            let rs = try db!.executeQuery(sql, values: nil)
            while rs.next() {
                return Int(rs.int(forColumnIndex: 0))
            }
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }
        return 0
    }

    func existItem(item: MenuInfo) -> Bool {
        let sql = "SELECT * FROM HomeItemTable WHERE id=?"

        do {
            let rs = try db!.executeQuery(sql, values: [item.id])
            while rs.next() {
                return true
            }
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }
        return false
    }
    
    //MARK: - 删除表
    func deleteTable() {
        let sql = String.init(format: "DROP TABLE %@", tableName)
        do {
            try db?.executeUpdate(sql, values: nil)
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }
    }
    
    //MARK: -清空表
    func eraseTable() {
        let sql = String.init(format: "DELETE FROM %@", tableName)
        do {
            try db?.executeUpdate(sql, values: nil)
        }catch {
            print("failed=====: \(error.localizedDescription)")

        }
    }
}
