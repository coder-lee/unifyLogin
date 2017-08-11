//
//  UserModel.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/16.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//"userId": "1f5ae32b1ada410283c1d30359641e43",//用户id
//"sexType": "未知",//性别
//"token": "ee8a1ab341b94267ad5e4c4d2e82d1e0",//登录token
//"userName": "",//用户昵称
//"MobilePhone": "15008294704",//用户手机号码
//"perStatus": "正常"//用户状态

@property (strong,nonatomic) NSString * _Nullable userId;

@property (strong,nonatomic) NSString * _Nullable sexType;

@property (strong,nonatomic) NSString * _Nullable token;

@property (strong,nonatomic) NSString * _Nullable userName;

@property (strong,nonatomic) NSString * _Nullable MobilePhone;

@property (strong,nonatomic) NSString * _Nullable perStatus;

@property (strong,nonatomic) NSString * _Nullable birthDay;

@property (strong,nonatomic) NSString * _Nullable photoUrl;


+ (void)saveAccount:(UserModel * __nonnull)user;

+ (UserModel * __nonnull)user;

+ (void)deleteAccount;
@end
