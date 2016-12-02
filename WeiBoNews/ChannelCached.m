//
//  ChannelCached.m
//  WeiBoNews
//
//  Created by 123456 on 16/11/18.
//  Copyright © 2016年 123456. All rights reserved.
//

#import "ChannelCached.h"
#import "DataBaseManager.h"

@implementation ChannelCached

- (id) init {
    self = [super init];
    if (self) {
        _db = [DataBaseManager defaultDBManager].dataBase;
    }
    return self;
}

- (void)createTable {
    NSString * sql = @"CREATE TABLE IF NOT EXISTS MyChannel (id VARCHAR(64),subscribe INTEGER, type VARCHAR(2048) DEFAULT NULL, name VARCHAR(64) DEFAULT NULL, uicode VARCHAR(64))";
    if ([_db executeUpdate:sql]) {
        NSLog(@"建表成功");
    }else {
        NSLog(@"建表失败(商家详情）：%@", [_db lastErrorMessage]);
    }
}

- (void)deleteClothid:(MenuInfo *)item {
    NSString * query = [NSString stringWithFormat:@"DELETE FROM MyChannel WHERE id = '%@'",item.id];
    [_db executeUpdate:query];
}

- (NSMutableArray *)readMessage{
    NSString * query = @"SELECT * FROM MyChannel";
    FMResultSet * rs = [_db executeQuery:query];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        MenuInfo *item = [[MenuInfo alloc] init];
        item.id = [rs stringForColumn:@"id"];
        item.subscribe = [rs intForColumn:@"subscribe"];
        item.type = [rs stringForColumn:@"type"];
        item.name = [rs stringForColumn:@"name"];
        item.uicode = [rs stringForColumn:@"uicode"];
        [array addObject:item];
    }
    //    [rs close];
    //NSLog(@"个数：%d", [array count]);
    return array;
}

-(BOOL)existsItem:(MenuInfo *)item
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM MyChannel WHERE id=?"];
    FMResultSet *rs=[_db executeQuery:sql,item.id];
    while ([rs next]) {
        return YES;
    }
    return NO;
}
-(void)insertItem:(MenuInfo *)item
{
    if ([self existsItem:item]) {
        return;
    }
    
    //拼接sql语句时，如果有动态内容，我们用?占位,避免字符串拼接失败,?号代表的值必须为对象类型
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO MyChannel (id,subscribe,type,name,uicode) VALUES (?,?,?,?,?)"];
    //插入也用executeUpdate方法
    if ([_db executeUpdate:sql,item.id, item.subscribe, item.type, item.name, item.uicode]) {
        NSLog(@"插入成功");
    }
    else{
        NSLog(@"数据插入失败:%@",[_db lastErrorMessage]);
    }
}
- (void)insertArray:(NSMutableArray *)arrayItem {
    //准备批量插入数据
    [_db beginTransaction];
    //不会直接对磁盘操作，先在内存中准备好
    for (MenuInfo *item in arrayItem) {
        [self insertItem:item];
    }
    //提交插入
    [_db commit];
}
-(NSInteger)count {
    NSString *sql = @"SELECT COUNT(*) FROM MyChannel";
    FMResultSet *result = [_db executeQuery:sql];
    while ([result next]) {
        return [result intForColumnIndex:0];
    }
    return 0;
}

// 清除表
- (BOOL)eraseTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        NSLog(@"Erase table error!");
        return NO;
    }
    
    return YES;
}

// 删除表
- (BOOL)deleteTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        NSLog(@"Delete table error!");
        return NO;
    }
    
    return YES;
}

@end
