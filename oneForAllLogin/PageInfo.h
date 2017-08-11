//
//  PageInfo.h
//  smartCampus
//
//  Created by witaction on 2017/5/3.
//  Copyright © 2017年 witaction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageInfo : NSObject
@property (nonatomic,strong)NSString *ClassName;
@property (nonatomic,strong)NSString *Title;
@property (nonatomic,strong)NSString *Image;
@property (nonatomic,strong)NSString *SelectImage;

+(UITabBarController *) instanceTabbarController;
@end
