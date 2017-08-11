//
//  LoginViewController.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoginType) {
    PhoneLogin = 0,
    AccountLogin
};

@interface LoginViewController :BaseViewController

@property  (nonatomic, assign)LoginType *loginType;

-(void)setAppkey:(NSString *)appKeyStr andSn:(NSString *)snStr andHomePageBundleName:(NSString *)bundleName;

@end
