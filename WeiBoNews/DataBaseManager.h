//
//  DataBaseManager.h
//  CreateDataBase
//
//  Created by  刘洪君 on 14-5-10.
//  Copyright (c) 2014年 LHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataBaseManager : NSObject {
    NSString *_name;
}
@property (nonatomic, strong) FMDatabase *dataBase;

+(DataBaseManager *) defaultDBManager;

@end
