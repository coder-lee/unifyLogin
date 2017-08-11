//
//  HistoryModel.h
//  oneForAllLogin
//
//  Created by leo on 2017/7/11.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject
//Address = "\U4e0d\U77e5\U90531";
//CityCode = 150700;
//Latitude = "123.333333";
//LoginIPAddr = 1231;
//Longitude = "112.111111";
//ModIPAddr = 1231;
//Name = "\U5e0c\U671b\U5c0f\U5b661";
@property (strong, nonatomic) NSMutableArray * _Nullable array;

@property (strong,nonatomic) NSString * _Nullable Address;

@property (strong,nonatomic) NSString * _Nullable CityCode;

@property (strong,nonatomic) NSString * _Nullable Latitude;

@property (strong,nonatomic) NSString * _Nullable LoginIPAddr;

@property (strong,nonatomic) NSString * _Nullable Longitude;

@property (strong,nonatomic) NSString * _Nullable ModIPAddr;

@property (strong,nonatomic) NSString * _Nullable Name;

+ (void)saveHistoryArray:(HistoryModel * __nonnull)history;

+ (NSMutableArray * __nonnull)historyArray;

+ (void)deleteHistory;

+ (void)saveHistoryModel:(HistoryModel * __nonnull)history;

+(HistoryModel *__nonnull)history;

@end
