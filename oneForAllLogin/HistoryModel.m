//
//  HistoryModel.m
//  oneForAllLogin
//
//  Created by leo on 2017/7/11.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "HistoryModel.h"

@implementation HistoryModel

+ (void)saveHistoryModel:(HistoryModel * __nonnull)history {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:history.array];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KHistory];

}

+(HistoryModel *__nonnull)history {
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:KHistory];
    if (data) {
        HistoryModel *history;
        
        history= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return history;
    }else {
        
        return nil;
    }

}

#pragma mark 保存数据
+ (void)saveHistoryArray:(HistoryModel * __nonnull)history {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:history.array];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KHistoryArray];
}

#pragma mark  取数据并转模型
+ (NSMutableArray * __nonnull)historyArray {
    
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:KHistoryArray];
    if (data) {
        HistoryModel *history;
        
        history.array= [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        return history.array;
    }else {
        
        return nil;
    }
}

+ (void)deleteHistory {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KHistory];
}

@end
