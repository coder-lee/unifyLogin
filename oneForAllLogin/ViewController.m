//
//  ViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "ViewController.h"
#import "SettingTableViewController.h"
#import "SecondLoginViewController.h"
#import "LoginViewController.h"
#import "PageInfo.h"

static BOOL showLoginView =NO;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *loginString = [[NSUserDefaults standardUserDefaults]objectForKey:KSecondLogin];
    NSString *codeString = [[NSUserDefaults standardUserDefaults] objectForKey:KFirstLogin];
    if (showLoginView) {
        
        if ([loginString isEqualToString:KSecondLogin]) {
            SettingTableViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
            
            //        [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else if ([codeString isEqualToString:KFirstLogin]) {
            UITabBarController *tabbar = [PageInfo instanceTabbarController];
            [self presentViewController:tabbar animated:YES completion:nil];
        }
        else {
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            UINavigationController *nav= [[UINavigationController alloc]initWithRootViewController:vc];
            
            [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
        }

    }
    else {
        if ([loginString isEqualToString:KSecondLogin]) {
            SettingTableViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
            
            //        [[UIApplication sharedApplication].keyWindow setRootViewController:vc];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else {
            UITabBarController *tabbar = [PageInfo instanceTabbarController];
            [self presentViewController:tabbar animated:YES completion:nil];
        }

    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
