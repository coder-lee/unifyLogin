//
//  HttpUrls.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#ifndef HttpUrls_h
#define HttpUrls_h

//#define BaseURL @"http://192.168.0.15:889/"
#define BaseURL @"http://192.168.0.231/zx_UMP/WebApi/"
#define BaseImageURL @"http://192.168.0.231/zx_UMP/"
/*
                    [BaseURL stringByAppendingString:@""]
 */
//获得应用服务所在的城市列表
#define KGET_CityList [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=GetOpenCityList"]

//获得应用服务列表
#define KGET_ServceList [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=GetParkSystemList"]

//获取验证码
#define KGET_VerificationCode [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=GetLoginCode"]

//手机验证码登录
#define KLoginByVerificationCode [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=MobileLogin"]

//账号密码注册
#define KRegiter [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=UserAcountRegister"]

//账号密码登录
#define KLoginByAccount [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=AcountLogin"]


//修改用户绑定的手机 IMobieApiHandler.ashx?action=ModifyMobile
#define KChangeUser_Phone [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=ModifyMobile"]

//修改用户基本信息 IMobieApiHandler.ashx?action=ModifyUserInfo
#define KChangeUser_Info [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=ModifyUserInfo"]

//修改用户头像 IMobieApiHandler.ashx?action=AddUserPhoto
#define KChangeUser_HeaderImg [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=AddUserPhoto"]

//获取广告列表
#define KGetAD_List [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=GetAdvertList"]

//添加单位收藏
#define KAddCollectSys [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=AddCollectSys"]

//删除单位收藏
#define KDeleteCollectSys [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=DeleteCollectSys"]

//获取用户单位收藏列表
#define KGetCollectSysData [BaseURL stringByAppendingString:@"IMobieApiHandler.ashx?action=GetCollectSysData"]

#endif /* HttpUrls_h */
