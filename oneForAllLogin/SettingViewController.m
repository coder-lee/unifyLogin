//
//  SettingViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/7/6.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "SettingsTableViewController.h"
#import "LoginViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setExtraCellLineHidden:_tableView];
    
    _headerImg.layer.masksToBounds = YES;
    
    _headerImg.layer.cornerRadius = 35.0f;
    
    

}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self creatUI];

}
-(void)creatUI {
    UserModel *user = [UserModel user];
    
    [_headerImg setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholder:[UIImage imageNamed:@"-icon_headerImgView_default"] options:YYWebImageOptionRefreshImageCache completion:nil];
    
    _nameLabel.text = user.userName;
    
    [_tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserModel *user = [UserModel user];
    SettingViewCell *cell;
    
    if (!cell) {
        if (indexPath.row ==0) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil] lastObject];
        }
        else {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil] firstObject];
            
            switch (indexPath.row) {
                case 1: {
                    cell.TitleLabel.text = @"昵称";
                    cell.NameLabel.text = user.userName;
                }
                    break;
                case 2: {
                    cell.TitleLabel.text = @"性别";
                    cell.NameLabel.text = user.sexType;

                }
                    break;

                case 3: {
                    cell.TitleLabel.text = @"生日";
                    cell.NameLabel.text = user.birthDay;

                }
                    break;

                case 4: {
                    cell.TitleLabel.text = @"手机";
                    cell.NameLabel.text = user.MobilePhone;

                }
                    break;

//                case 5: {
//                    cell.TitleLabel.text = @"省份";
//                    cell.NameLabel.text = @"";
//
//                }
                    break;

                    
                default:
                    break;
            }

        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        SettingsTableViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SettingsTableViewController"];
        
//        [self.navigationController pushViewController:vc animated:YES];
        [self showViewController:vc sender:nil];
    }
}
//隐藏cell多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
#pragma mark - 按钮点击事件

- (IBAction)btnAction:(id)sender {
    switch ([sender tag]) {
//            重新绑定手机
        case 100: {
            [self changePhone];
        }
            break;
//            切换平台账号
        case 101: {
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        }
            break;
            
        default:
            break;
    }
}
-(void)changePhone {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入手机号" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.placeholder = @"";
    [alert showWithCompletionHandler:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1:
            {
                if (![txtName.text isPhone]) {
                    [SVProgressHUD showInfoWithStatus:@"请输入正确的电话号码"];
                    [SVProgressHUD dismissWithDelay:0.5f];
                    return;
                }
                UserModel *user = [UserModel user];
                NSDictionary *dic = @{@"userid":user.userId,@"mobile":txtName.text};
                [[HttpManager getInstance] GetRequest:KChangeUser_Phone params:dic success:^(id responseObj) {
                    if ([[responseObj objectForKey:@"ProResult"]intValue] ==0) {
                        [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                        [SVProgressHUD dismissWithDelay:0.5f];
//                        [_phoneBtn setTitle:txtName.text forState:0];
                        UserModel *user = [UserModel user];
                        user.MobilePhone = txtName.text;
                        [UserModel saveAccount:user];
                        
                        [_tableView reloadData];
                    }
                    else {
                        [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
                        [SVProgressHUD dismissWithDelay:0.5f];
                        
                    }
                } failure:^(NSError *error) {
                    [SVProgressHUD showInfoWithStatus:@"绑定失败,请稍后重试"];
                    [SVProgressHUD dismissWithDelay:0.5f];
                    
                }];
            }
                break;
                
            default:
                break;
        }
        
        
    }];

}
@end
