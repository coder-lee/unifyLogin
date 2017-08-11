//
//  SecondLoginViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/14.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "SecondLoginViewController.h"
#import "SettingTableViewController.h"
#import "PageInfo.h"

@interface SecondLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
@property (weak, nonatomic) IBOutlet UIButton *rechooseScBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation SecondLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = YES;
    
    
    _loginBtn.layer.masksToBounds = YES;
    
    _loginBtn.layer.cornerRadius = 5.0f;
    
    _rechooseScBtn.layer.masksToBounds = YES;
    
    _rechooseScBtn.layer.cornerRadius = 5.0f;
    
    _accountTF.text = @"lxl";
    _pwdTF.text = @"1";
    
    
    
    self.navLabel.text = self.navString;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)LoginBtnClick:(id)sender {
    //TODO
    if (_accountTF.text.length ==0) {
        [self shake:_accountTF];
        return;
    }
    if (_pwdTF.text.length ==0) {
        [self shake:_pwdTF];
        return;
    }
        NSDictionary *dic = @{@"loginType":@"4",@"userName":_accountTF.text,@"password":_pwdTF.text};
    
        [SVProgressHUD showInfoWithStatus:KLoading];
    
//        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    :[NSString stringWithFormat:@"http://%@/IMobileLoginHandler.ashx",[userdefaults objectForKey:KIpString]]
        [[HttpManager getInstance]GetRequest:@"http://192.168.0.15:886/IMobileLoginHandler.ashx" params:dic success:^(id responseObj) {
            if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
    
                [SVProgressHUD showInfoWithStatus:@"登录成功"];
                [SVProgressHUD dismissWithDelay:0.5f];
    
                [[NSUserDefaults standardUserDefaults] setObject:KSecondLogin forKey:KSecondLogin];
                
                [self saveHistory];
    
                SettingTableViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
    
                [vc setHidesBottomBarWhenPushed:YES];
    
                [self showViewController:vc sender:nil];
    
    
            }
            else {
    
                [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
                [SVProgressHUD dismissWithDelay:0.5f];
    
            }
        } failure:^(NSError *error) {
    
        }];
    
}
- (IBAction)rechooseBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 保存最近登录历史
-(void)saveHistory {
    
    UserModel *user = [UserModel user];
    
    NSDictionary *dic = @{@"userid":user.userId,@"SysID":self.sysIdStr};
    
    [[HttpManager getInstance] GetRequest:KAddCollectSys params:dic success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"ProResult"] intValue] ==0) {
            
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
