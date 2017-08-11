//
//  SecondLoginViewController.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/14.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondLoginViewController : BaseViewController


@property(nonatomic, strong) NSString *ipString;

@property (weak, nonatomic) IBOutlet UILabel *navLabel;

@property(nonatomic, strong) NSString *navString;

/**
 系统部署点ip
 */
@property (nonatomic, strong)NSString *sysIdStr;

@end
