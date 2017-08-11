//
//  RegisterViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/14.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *firstPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *secondPwdTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    _registerBtn.layer.masksToBounds = YES;
    
    _registerBtn.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registerBtnClick:(id)sender {
    if (_accountTF.text.length ==0) {
        [self shake:_accountTF];
        return;
    }
    if (_firstPwdTF.text.length ==0) {
        [self shake:_firstPwdTF];
        return;
    }
    if (_secondPwdTF.text.length ==0) {
        [self shake:_secondPwdTF];
        return;
    }
    if (![_firstPwdTF.text isEqualToString:_secondPwdTF.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一样"];
        
        [SVProgressHUD dismissWithDelay:0.5f];
        return;
    }
    NSDictionary *dic = @{@"acount":[NSString stringWithFormat:@"%@",_accountTF.text],@"pwd":[NSString stringWithFormat:@"%@",_firstPwdTF.text]};
    
    [[HttpManager getInstance]GetRequest:KRegiter params:dic success:^(id responseObj) {
        if ([[responseObj objectForKey:@"ProResult"]intValue]==0) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [SVProgressHUD dismissWithDelay:0.5f];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
            [SVProgressHUD dismissWithDelay:0.5f];

        }
    } failure:^(NSError *error) {
        [SVProgressHUD showInfoWithStatus:@"注册失败,请稍后重试"];
        [SVProgressHUD dismissWithDelay:0.5f];

    }];
}


@end
