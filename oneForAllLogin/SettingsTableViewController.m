//
//  SettingsTableViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/16.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "LoginViewController.h"
#import "DateView.h"
#import "AESCipher.h"
#import <CommonCrypto/CommonCryptor.h>

#define K_Sn @"SCHOOLAPP"
#define KAppKey @"fa8cea8e94144887a15d088b0c4b03fb"

#define KSecretKey @"008e2caa320947c68322f28e427e0d11"


@interface SettingsTableViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL editType;
    NSString *ageString;
}
@property (weak, nonatomic) IBOutlet UITextField *nickNameTF;

@property (weak, nonatomic) IBOutlet UISegmentedControl *sexSegment;

@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;



@property (strong, nonatomic) DateView *dateView;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setExtraCellLineHidden:self.tableView];
    
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationController.navigationBar.barTintColor = MainColor;

    [self setNavTitle:@"设置"];
    
    [self setRightButtonWithTitle:@"编辑" action:@selector(editBtnClick)];
    
    [self setLeftButtonWithImage:[UIImage imageNamed:@"-icon_back"] hImage:nil action:@selector(backBtnClick)];
    
    editType = NO;
    
    _birthdayBtn.userInteractionEnabled = NO;
    
    _nickNameTF.userInteractionEnabled = NO;
    
    _sexSegment.userInteractionEnabled = NO;
    UserModel *user = [UserModel user];
    _nickNameTF.text =user.userName;
    
    _sexSegment.selectedSegmentIndex =[user.sexType isEqualToString:@"男"]?0:1;
    
    [_birthdayBtn setTitle:user.birthDay forState:0];
    
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.cornerRadius = 40.0f;
    
    
    
    [_headerImg setImageWithURL:[NSURL URLWithString:user.photoUrl] placeholder:[UIImage imageNamed:@"头像"] options:YYWebImageOptionRefreshImageCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    
    }];
    
    [_phoneBtn setTitle:[UserModel user].MobilePhone forState:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source


- (IBAction)quietLogin:(id)sender {
    LoginViewController *vc =[[UIStoryboard  storyboardWithName:@"Login" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [[UIApplication sharedApplication].keyWindow setRootViewController:nav];
}

#pragma mark 编辑 &保存
-(void)editBtnClick {
    editType = !editType;
    
    if (editType) {
        [self setRightButtonWithTitle:@"保存" action:@selector(editBtnClick)];
        _nickNameTF.userInteractionEnabled = YES;
        [_nickNameTF becomeFirstResponder];
        
        _sexSegment.userInteractionEnabled = YES;
        
        _birthdayBtn.userInteractionEnabled = YES;
    }
    else {
        [self setRightButtonWithTitle:@"编辑" action:@selector(editBtnClick)];
        _nickNameTF.userInteractionEnabled = NO;
        [_nickNameTF resignFirstResponder];
        
        _sexSegment.userInteractionEnabled = NO;
        
        _birthdayBtn.userInteractionEnabled = NO;
        
        [self load];
    }
}

- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
#pragma mark 生日
- (IBAction)birthdayBtnClick:(id)sender {
    [self.view addSubview:self.dateView];
}

#pragma mark 保存
-(void)load {
    [SVProgressHUD showWithStatus:KLoading];
    
    NSString *string = _sexSegment.selectedSegmentIndex ==0?@"男":@"女";
    UserModel *user = [UserModel user];
    
    NSDictionary *dic = @{@"userid":user.userId,@"nicName":_nickNameTF.text,@"sex":string,@"BirthDay":_birthdayBtn.currentTitle};
    
    [[HttpManager getInstance]GetRequest:KChangeUser_Info params:dic success:^(id responseObj) {
        if ([[responseObj objectForKey:@"ProResult"]isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [SVProgressHUD dismissWithDelay:1.0f];
            NSDictionary *dic = [responseObj objectForKey:@"Msg"];
//            [[NSUserDefaults standardUserDefaults]setObject:dic forKey:KUserModel];
            UserModel *user = [UserModel modelWithDictionary:dic];
            
            NSLog(@"%@",user.userId);
            
            [UserModel saveAccount:user];

        }
        else {
            [SVProgressHUD showWithStatus:@"修改失败,请稍后重试"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(DateView *)dateView {
    if (!_dateView) {
        _dateView = [DateView instanceDateView];
        _dateView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH-48);
        [_dateView.doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_dateView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_dateView.datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _dateView;
}
- (void)doneBtnClick {
    [_birthdayBtn setTitle:ageString forState:0];
    
    [self.dateView removeFromSuperview];
}

- (void)cancleBtnClick {
    [self.dateView removeFromSuperview];
}
- (void) datePickerValueChanged:(id)sender {
    UIDatePicker *control = (UIDatePicker*)sender;
    NSDate* sDate = control.date;
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd"];
    NSString *sTime = [formatter1 stringFromDate:sDate];
    
    ageString = sTime;
    
}
- (IBAction)headerImgClick:(id)sender {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    [manager resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    [actionSheet showInView:self.view withCompletionHandler:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:picker animated:YES completion:nil];
                }
            }break;
            case 1:{
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:nil];
                }
            }break;
            default:break;
                
        }
    }];

}
/**********************************************************************/
#pragma mark - UIImagePickerControllerDelegate
/**********************************************************************/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *avatarImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        
        [self uploadWithImg:avatarImage];
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadWithImg:(UIImage *)img {
    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    UserModel *user = [UserModel user];
    [dic setValue:user.userId forKey:@"userid"];
        [dic setValue:[self getKey] forKey:@"sign"];
        [dic setValue:K_Sn forKey:@"sn"];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer.timeoutInterval =30;//超时
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json", @"text/html", nil];
        
        [manager POST:KChangeUser_HeaderImg parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            
            NSData *data = UIImagePNGRepresentation(img);
            
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            //上传
            /*
             此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"]
             3. 要保存在服务器上的[文件名]
             4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
            //上传进度
            // @property int64_t totalUnitCount;     需要下载文件的总大小
            // @property int64_t completedUnitCount; 当前已经下载的大小
            //
            // 给Progress添加监听 KVO
            //        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            // 回到主队列刷新UI,用户自定义的进度条
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showProgress: 1.0 *
                 uploadProgress.completedUnitCount / uploadProgress.totalUnitCount];
            });
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [SVProgressHUD dismiss];
            if ([[responseObject objectForKey:@"ProResult"]intValue] ==0) {
                

                [_headerImg setImageWithURL:[NSURL URLWithString:[responseObject objectForKey:@"Msg"]] placeholder:[UIImage imageNamed:@"头像"] options:YYWebImageOptionRefreshImageCache completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    [SVProgressHUD showSuccessWithStatus:@"上传成功"];
                    [SVProgressHUD dismissWithDelay:0.5f];
                }];
            }
            else {
                

                [SVProgressHUD showWithStatus:[responseObject objectForKey:@"Msg"]];
                [SVProgressHUD dismissWithDelay:1.0f];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVProgressHUD dismiss];

            [SVProgressHUD showSuccessWithStatus:error.localizedDescription];
            [SVProgressHUD dismissWithDelay:1.0f];

            NSLog(@"上传失败 %@", error);
        }];
        
    

}
#pragma mark 获取加密key
-(NSString *)getKey {
    //    1497249628960  32
    NSString *key = [NSString stringWithFormat:@"%@_%@",KAppKey,[self getTime]];
    
    NSString *string = aesEncryptString(key, KSecretKey);
    //    Rsc+vqwCpQP+pSdaZSVehTXcX23YMa8tEAN+5/Rtij8=
    return string;
}
-(NSString *)getTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval=[date timeIntervalSince1970]*1000;
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", timeInterval];
    
    return timeString;
}
- (IBAction)phoneBtnClick:(id)sender {
    if (![_phoneBtn.currentTitle isPhone]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的手机号"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;
    }
    if (_nickNameTF.text.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"请输入昵称"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;

    }
    if(_birthdayBtn.currentTitle.length ==0) {
        [SVProgressHUD showInfoWithStatus:@"请选择你的生日"];
        [SVProgressHUD dismissWithDelay:1.0f];
        return;

    }
//    NSDictionary *dic = @{@"userid":[UserModel instance].userId,@"mobile":};
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
                                [_phoneBtn setTitle:txtName.text forState:0];
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
