//
//  DataBaseManager.m
//  CreateDataBase
//
//  Created by  刘洪君 on 14-5-10.
//  Copyright (c) 2014年 LHJ. All rights reserved.
//

#import "DataBaseManager.h"

#define kDefaultDBName @"account.db"

@implementation DataBaseManager
static DataBaseManager * _sharedDBManager;

+ (DataBaseManager *) defaultDBManager {
	if (!_sharedDBManager) {
		_sharedDBManager = [[DataBaseManager alloc] init];
	}
	return _sharedDBManager;
}

- (id) init {
    self = [super init];
    if (self) {
        int state = [self initializeDBWithName:kDefaultDBName];
        if (state == -1) {
            NSLog(@"数据库初始化失败");
        } else {
            NSLog(@"数据库初始化成功");
        }
    }
    return self;
}

- (int) initializeDBWithName : (NSString *) name {
    if (!name) {
		return -1;  // 返回数据库创建失败
	}
    // 沙盒Docu目录
    NSString * docp = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
	_name = [docp stringByAppendingString:[NSString stringWithFormat:@"/%@",name]];
    NSLog(@"数据库路径：%@", _name);
	NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:_name];
    [self connect];
    if (!exist) {
        return 0;
    } else {
        return 1;// 返回数据库已经存在
	}
}
/// 连接数据库

- (void) connect {
	if (!self.dataBase) {
		self.dataBase = [[FMDatabase alloc] initWithPath:_name];
	}
    self.dataBase.shouldCacheStatements = YES;
	if (![_dataBase open]) {
		NSLog(@"不能打开数据库");
	}
}













@end
