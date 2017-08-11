//
//  ServceModel.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/14.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServceModel : NSObject
//"Name": "成都信息工程大学",//部署名称
//"LoginIPAddr": "zxdoorssos.witaction.com:808/zxdoorssos",//登录ip地址
//"ModIPAddr": "zxdoor.witaction.com:808/zxdoor",//业务ip地址
//"Latitude": "30.58004",//纬度
//"Longitude": "103.9894",//经度
//"CityCode": "510100",//城市编码
//"Address": "成都信息工程大学航空港校区"//部署地址
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *LoginIPAddr;

@property (nonatomic, strong) NSString *ModIPAddr;

@property (nonatomic, strong) NSString *Latitude;

@property (nonatomic, strong) NSString *Longitude;

@property (nonatomic, strong) NSString *CityCode;

@property (nonatomic, strong) NSString *Address;

@end
