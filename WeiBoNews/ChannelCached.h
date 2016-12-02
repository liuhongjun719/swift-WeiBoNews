//
//  ChannelCached.h
//  WeiBoNews
//
//  Created by 123456 on 16/11/18.
//  Copyright © 2016年 123456. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WeiBoNews-Swift.h"
#import "MenuInfo.h"
#import "FMDB.h"
#define  kNoticeBoardMessage @"NoticeBoardMessage"

@interface ChannelCached : NSObject
@property (nonatomic, strong) FMDatabase *db;

- (void)createTable;

- (void)deleteClothid:(MenuInfo *)item;
- (NSMutableArray *)readMessage;
- (void)insertArray:(NSMutableArray *)arrayItem;
-(void)insertItem:(MenuInfo *)item;

//- (NSMutableAhttp://mail.ucanit.cn:888/exchange/rray *)readDataOfItemFromIndex:(NSInteger)startIndex count:(NSInteger)count;
-(NSInteger)count;
-(BOOL)existsItem:(MenuInfo *)item;
- (BOOL)deleteTable:(NSString *)tableName;
- (BOOL)eraseTable:(NSString *)tableName;

@end
