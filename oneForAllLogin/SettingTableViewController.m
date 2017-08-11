//
//  SettingTableViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/15.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SecondLoginViewController.h"
#import "ChooseViewController.h"
#import "LoginViewController.h"

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self setLeftButtonWithTitle:nil action:nil];
    [self setNavTitle:@"设置"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            //          切换账号
        case 0:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KSecondLogin];
            SecondLoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SecondLoginViewController"];
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
        }
            break;
            //            切换学校
        case 1:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KSecondLogin];
            ChooseViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChooseViewController"];
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
            
        }
            break;
            //            退出平台
        case 2:
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KFirstLogin];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:KSecondLogin];
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
            
        }
            break;
        case 3:
        {
            NSURL *url = [NSURL URLWithString:@"com.witaction.uuc://201"];
            
            

            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                LOG(@"调起uuc");
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    
                }];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"你尚未安装融合通讯,请问是否前往App Store安装?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 0:
                            
                            break;
                        case 1:
                            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@" itms://itunes.apple.com"]];
                            break;

                            
                        default:
                            break;
                    }
                }];
                [SVProgressHUD dismissWithDelay:0.5f];
            }
            
        }
            break;

            
            
        default:
            break;
    }
}
@end
