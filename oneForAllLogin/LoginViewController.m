//
//  LoginViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "LoginViewController.h"
#import "ChooseViewController.h"
#import "SettingTableViewController.h"
#import "PageInfo.h"
#import <ShareSDK/ShareSDK.h>


// 是否有第三方登录
static BOOL showThirdPartyLogin =YES;

//是否显示 上面的segment  这个和下面的showPhoneLogin 是连着一起用的
static BOOL showLoginTypeSegment = YES;

// yes 显示手机账号登录  no  显示账号登录  (这个和上面的showLoginType选择为NO时,那么就没有segment  就选择显示手机登录还是账号密码登录)
static BOOL showPhoneLogin = YES;

@interface LoginViewController ()
{
    /**
     *  定时器
     */
    NSTimer *timer;
    /**
     *  获取验证码倒计时
     */
    NSInteger  count;
    
}

@property (weak, nonatomic) IBOutlet UITextField *PhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;
- (IBAction)loginBtnClick:(id)sender;

@property (strong, nonatomic) NSString *phoneString;

@property (strong, nonatomic) NSString *accountString;

@property (weak, nonatomic) IBOutlet UIButton *phoneTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *accountTypeBtn;
@property (weak, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *typeView;

@property (weak, nonatomic) IBOutlet UIButton *getV_CodeBtn;
- (IBAction)getV_CodeBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *QQBtn;
- (IBAction)QQBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *WxBtn;
- (IBAction)WxBtnClick:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *WbBtn;
- (IBAction)WbBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginBtn.layer.masksToBounds = YES;
    
    _loginBtn.layer.cornerRadius = 5.0f;
    
    _registerBtn.layer.masksToBounds = YES;
    
    _registerBtn.layer.cornerRadius = 5.0f;
    
    
    _PhoneTF.text = @"15828628978";
    
    _pwdTF.text = @"111111";
    
    _getV_CodeBtn.backgroundColor = [UIColor colorWithRed:19/255.0f green:222/255.0f blue:105/255.0f alpha:0.1f];
    
    _getV_CodeBtn.layer.cornerRadius = 5;
    
    _getV_CodeBtn.layer.borderColor = RGB(19, 222, 105).CGColor;
    
    _getV_CodeBtn.layer.borderWidth = 1;
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    //不显示第三方登录
    if (!showThirdPartyLogin) {
        [self hideThirdPartyLogin];
        //设置默认的登录类型
        _loginType =PhoneLogin;
        [_phoneTypeBtn setSelected:YES];
    }
    //显示第三方登录
    else {
    }
    //不显示segment
    if (!showLoginTypeSegment) {
        //显示手机登录
        [_phoneTypeBtn setHidden:YES];
        [_phoneTypeLabel setHidden:YES];
        [_typeView setHidden:YES];
        
        [_accountTypeBtn setHidden:YES];
        [_accountTypeLabel setHidden:YES];
        if (showPhoneLogin) {
            _loginType = PhoneLogin;
            
            [self hideR_and_F_and_G_Btn];
        }
        //显示账号登录
        else {
            _loginType = AccountLogin;
            [self showR_and_F_and_G_Btn];
        }
    }
    //显示segment
    else {
        _loginType = PhoneLogin;
        
        [_phoneTypeBtn setSelected:YES];
        
        
    }
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark 登录
- (IBAction)loginBtnClick:(id)sender {
    if (_phoneTypeBtn.selected) {
        _loginType = PhoneLogin;
    }
    else {
        _loginType =AccountLogin;
    }
    //手机账号登录
    if (_loginType ==PhoneLogin) {
        if (![_PhoneTF.text isPhone]) {
            [self shake:_PhoneTF];
            
            return;
        }
        //  isMobilphoneCode  这里验证码正则表达式是6位数字
        if (_pwdTF.text.length == 0 || [_pwdTF.text isMobilphoneCode]) {
            [self shake:_pwdTF];
            
            return;
        }
        
        //    TODO   后续请求
        NSDictionary *dic = @{@"mobile":_PhoneTF.text,@"CheckCode":_pwdTF.text};
        
        [[HttpManager getInstance]GetRequest:KLoginByVerificationCode params:dic success:^(id responseObj) {
            
            if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
                
                UserModel *user = [UserModel modelWithDictionary:[responseObj objectForKey:@"Msg"]];
                NSLog(@"%@",user.userId);
                
                [UserModel saveAccount:user];
                
//                UITabBarController *TabBar = [PageInfo instanceTabbarController];
                ChooseViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"ChooseViewController"];
                
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];

                [self.navigationController pushViewController:vc animated:YES];

            }
            else {
                
                [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
                
            }
        } failure:^(NSError *error) {
            
            [SVProgressHUD showInfoWithStatus:@"登录失败,请稍后重试"];
            [SVProgressHUD dismissWithDelay:0.5];
        }];
        
    }
    //账号密码登录
    else {
        if (_PhoneTF.text.length ==0) {
            [self shake:_PhoneTF];
            return;
        }
        if (_pwdTF.text.length ==0) {
            [self shake:_pwdTF];
            return;
        }
        
        NSDictionary *dic = @{@"acount":_PhoneTF.text,@"pwd":_pwdTF.text};
        
        [[HttpManager getInstance]GetRequest:KLoginByAccount params:dic success:^(id responseObj) {
            
            if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
                
                UserModel *user = [UserModel modelWithDictionary:[responseObj objectForKey:@"Msg"]];
                NSLog(@"%@",user.userId);
                
                [UserModel saveAccount:user];
                
                //                [[NSUserDefaults standardUserDefaults] setObject:dic forKey:KUserModel];
                
//                UITabBarController *TabBar = [PageInfo instanceTabbarController];
            
                ChooseViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"ChooseViewController"];
                
//                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                
//                [self presentViewController:vc animated:YES completion:nil];
                [self.navigationController pushViewController:vc animated:YES];
                
            }
            else {
                
                [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
                [SVProgressHUD dismissWithDelay:0.5];
                
            }
        } failure:^(NSError *error) {
            
            [SVProgressHUD showInfoWithStatus:@"登录失败,请稍后重试"];
            [SVProgressHUD dismissWithDelay:0.5];
        }];
        
    }
}
#pragma mark 隐藏第三方登录标识
-(void)hideThirdPartyLogin {
    [_QQBtn setHidden:YES];
    
    [_WxBtn setHidden:YES];
    
    [_WbBtn setHidden:YES];
}
#pragma mark 隐藏获取验证码 注册 忘记密码
-(void)hideR_and_F_and_G_Btn {
    [_getV_CodeBtn setHidden:YES];
    
    [_registerBtn setHidden:NO];
    
    [_forgetPwdBtn setHidden:NO];
    
    _phoneLabel.text = @"账号";
    
    _PhoneTF.keyboardType = UIKeyboardTypeDefault;
    
    _codeLabel.text = @"密码";
    
    _pwdTF.keyboardType =UIKeyboardTypeDefault;
    
}

-(void)showR_and_F_and_G_Btn {
    
    [_getV_CodeBtn setHidden:NO];
    
    [_registerBtn setHidden:YES];
    
    [_forgetPwdBtn setHidden:YES];
    
    _phoneLabel.text = @"手机号";
    _PhoneTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeLabel.text = @"验证码";
    _pwdTF.keyboardType =UIKeyboardTypeNumberPad;
}

#pragma mark QQ登录
- (IBAction)QQBtnClick:(id)sender {
    //TODO
    //例如QQ的登录
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

#pragma mark 微博登录
- (IBAction)WbBtnClick:(id)sender {
    //TODO
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
        }
        
        else
        {
            NSLog(@"%@",error);
        }

    }];
}

#pragma mark 微信登录
- (IBAction)WxBtnClick:(id)sender {
    //TODO
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess)
        {
            
            NSLog(@"uid=%@",user.uid);
            NSLog(@"%@",user.credential);
            NSLog(@"token=%@",user.credential.token);
            NSLog(@"nickname=%@",user.nickname);
        }
        
        else
        {
            NSLog(@"%@",error);
        }
        
    }];

}

#pragma mark 获取验证码
- (IBAction)getV_CodeBtnClick:(id)sender {
    
    if (![_PhoneTF.text isPhone]) {
        [self shake:_PhoneTF];
        return;
    }
    NSDictionary *dic = @{@"mobile":_PhoneTF.text};
    
    [[HttpManager getInstance]GetRequest:KGET_VerificationCode params:dic success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            count = 60;
            [_PhoneTF resignFirstResponder];
            if ([_getV_CodeBtn.currentTitle isEqualToString:@"获取验证码"]) {
                
                timer                                 = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startCount_down:) userInfo:nil repeats:YES];
                [_getV_CodeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
            }
            
        }
        else {
            [SVProgressHUD showWithStatus:[responseObj objectForKey:@"Msg"]];
            [SVProgressHUD dismissWithDelay:0.5f];
        }
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark 开启倒计时
-(void)startCount_down:(NSTimer *)time {
    if (count == 1) {
        [_getV_CodeBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [_getV_CodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getV_CodeBtn.userInteractionEnabled = YES;
        [time invalidate];
    }else {
        count--;
        [_getV_CodeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)count] forState:UIControlStateNormal];
        _getV_CodeBtn.userInteractionEnabled = NO;
    }
}



- (IBAction)typeBtnClick:(id)sender {
    switch ([sender tag]) {
            //            手机
        case 0:
        {
            [self showR_and_F_and_G_Btn];
            
            _phoneTypeBtn.selected = YES;
            _accountTypeBtn.selected = NO;
            
            _accountTypeLabel.textColor = [UIColor lightGrayColor];
            _phoneTypeLabel.textColor = RGB(19, 222, 105);
            
            _typeView.centerX = _phoneTypeLabel.centerX;
        }
            break;
            //            账号
        case 1:
        {
            [self hideR_and_F_and_G_Btn];
            
            _phoneTypeBtn.selected = NO;
            _accountTypeBtn.selected = YES;
            
            _phoneTypeLabel.textColor = [UIColor lightGrayColor];
            _accountTypeLabel.textColor = RGB(19, 222, 105);
            
            _typeView.centerX = _accountTypeLabel.centerX;
            
            
        }
            break;
        default:
            break;
    }
}

@end
