//
//  NoticeBoardMessageCached.h
//  YouKang
//
//  Created by 123456 on 15/4/28.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiBoNews-Swift.h"
#import "FMDB.h"
#define  kNoticeBoardMessage @"NoticeBoardMessage"
@interface NoticeBoardMessageCached : NSObject

@property (nonatomic, strong) FMDatabase *db;

- (void)createTable;

- (void)deleteClothid:(MenuInfo *)item;
- (NSMutableArray *)readMessage;
- (void)insertArray:(NSMutableArray *)arrayItem;

-(NSInteger)count;
-(BOOL)existsItem:(MenuInfo *)item;
- (BOOL)deleteTable:(NSString *)tableName;
- (BOOL)eraseTable:(NSString *)tableName;

@end
