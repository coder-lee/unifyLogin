//
//  ChooseViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/13.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "ChooseViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "ServceModel.h"
#import "SecondLoginViewController.h"
#import "LoginViewController.h"
#import "LCBannerView.h"
#import "ChooseCell.h"
#import "DeleteButton.h"
#import "WebViewController.h"
static NSString *cellIdentifier = @"cellIdentifier";

@interface ChooseViewController ()<CLLocationManagerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,LCBannerViewDelegate,UISearchBarDelegate,DeleteButtonDelegate>
{
    
}

@property (nonatomic, strong) UIView *backBiew;
/**
 城市列表选择器
 */
@property (nonatomic, strong) UIView *pickerView;

/**
 选择器选择的城市Name
 */
@property (nonatomic, strong) NSString *cityString;

/**
 选择器选择的城市Code
 */
@property (nonatomic, strong) NSString *codeString;

/**
 广告图ImageArray
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 收藏数组
 */
@property (nonatomic, strong) NSMutableArray *historyArray;

@property (nonatomic, strong) NSMutableArray *cityListArray;

@property (nonatomic, strong) NSMutableArray *detailListArray;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

// 用autolayout约束的，这个是距离顶部的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstraint;

/**
 轮播图
 */
@property (strong, nonatomic)LCBannerView *bannerScr;

@property (strong, nonatomic)  UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)cityBtnClick:(id)sender;

- (IBAction)LocationBtnCLick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *searchView;



@end

@implementation ChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self startLocation];
    
    //    _cityListArray = [NSMutableArray arrayWithObjects:@"成都",@"北京", nil];
    
    _detailListArray = [NSMutableArray array];
    
    [self getCityList];
    
    [self getAD_List];
    
    [self getHistory];
    _tableView.rowHeight = 60.0f;
    
    [self setExtraCellLineHidden:_tableView];
    
    [_activityIndicator setHidesWhenStopped:YES];
    
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark TableView Delegate &datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _detailListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChooseCell" owner:nil options:nil] firstObject];
        
        
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",[_detailListArray[indexPath.row] objectForKey:@"Name"]];
        
        cell.locationLabel.text = [NSString stringWithFormat:@"%@",[_detailListArray[indexPath.row] objectForKey:@"Address"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SecondLoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"SecondLoginViewController"];
    
    vc.ipString = [_detailListArray[indexPath.row] objectForKey:@"LoginIPAddr"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[_detailListArray[indexPath.row] objectForKey:@"LoginIPAddr"] forKey:KIpString];
    
    vc.navString = [_detailListArray[indexPath.row] objectForKey:@"Name"];
    
    vc.sysIdStr = [_detailListArray[indexPath.row] objectForKey:@"SysID"];
    
//    这里先讲选择的数据存在model里面，等后面登录成功了，作为最近登录的数据。
    HistoryModel *history = [HistoryModel modelWithDictionary:_detailListArray[indexPath.row]];
    
    [HistoryModel saveHistoryModel:history];
    
    [vc setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - banner delegete
- (void)bannerView:(LCBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    NSDictionary *dic = self.imageArray[index];
    
    WebViewController *web = [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"WebViewController"];
    
    web.urlStr = [dic objectForKey:@"AdvertUrl"];
    web.navStr = [dic objectForKey:@"AdvertName"];
    
    [self.navigationController pushViewController:web animated:YES];
    
}
#pragma mark 开启定位
-(void)startLocation {
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        if (IOS8_OR_LATER) {
            [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [_activityIndicator startAnimating];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [_activityIndicator stopAnimating];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             //             取消最后一个字     eg.成都市 - - - → 成都
             if ([city rangeOfString:@"市"].location != NSNotFound) {
                 city = [city substringToIndex:[city length]-1];
             }
             NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前城市:  %@",city]];
             //设置：在0-5个单位长度内的内容显示成红色
             [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(7, [str length]-7)];
             
             [_cityBtn setAttributedTitle:str forState:UIControlStateNormal];
             
             NSLog(@"定位完成:%@",city);
            
             [_activityIndicator stopAnimating];
             
             [self getServceListWithLon:@"" andLat:@"" andKeyWord:city andCityCode:@""];
             
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
             [_activityIndicator stopAnimating];

             [SVProgressHUD showWithStatus:@"定位失败,请稍后再试"];
             [SVProgressHUD dismissWithDelay:0.5];
             
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
             [_activityIndicator stopAnimating];
             [SVProgressHUD showWithStatus:@"定位失败,请稍后再试"];
             [SVProgressHUD dismissWithDelay:0.5];
         }
     }];
}
#pragma mark 选择城市
- (IBAction)cityBtnClick:(id)sender {
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"1111" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    //    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(12.0f,0, 200.0f, 300.0f)];
    //    tableView.delegate = self;
    //    tableView.dataSource = self;
    //    tableView.backgroundColor = [UIColor greenColor];
    //    [alert setValue:tableView forKey:@"accessoryView"];
    //
    //    [alert show];
    
    [self.view addSubview:self.pickerView];
    
    
    
}
#pragma mark pickerView Delegate&dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _cityListArray.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED {
    return [NSString stringWithFormat:@"%@",[_cityListArray[row] objectForKey:@"CityName"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED {
    NSLog(@"%ld %ld",component,row);
    
    _cityString = [_cityListArray[row] objectForKey:@"CityName"];
    _codeString = [_cityListArray[row] objectForKey:@"CityCode"];
    
}

#pragma mark 懒加载picker
-(UIView *)pickerView {
    if (!_pickerView) {
        //        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-SCREEN_HEIGTH/3, SCREEN_WIDTH, SCREEN_HEIGTH/3)];
        _pickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGTH)];
        _pickerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.1f];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-SCREEN_HEIGTH/3-30, SCREEN_WIDTH, SCREEN_HEIGTH/3+30)];
        view.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1.0f];
        [_pickerView addSubview:view];
        
        UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setFrame:CGRectMake(SCREEN_WIDTH-50,  SCREEN_HEIGTH-SCREEN_HEIGTH/3-30, 50, 30)];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:confirmBtn];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setFrame:CGRectMake(0,  SCREEN_HEIGTH-SCREEN_HEIGTH/3-30, 50, 30)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView addSubview:cancleBtn];
        
        UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGTH-SCREEN_HEIGTH/3, SCREEN_WIDTH, SCREEN_HEIGTH/3)];
        picker.delegate = self;
        picker.dataSource = self;
        [picker selectRow:0 inComponent:0 animated:YES];
        [picker reloadAllComponents];
        [_pickerView addSubview:picker];
    }
    return _pickerView;
}

-(void)confirmBtnClick {
    if ([self anySubViewScrolling:self.pickerView]) {
        return;
    }
    [self.pickerView removeFromSuperview];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前城市:  %@",_cityString]];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(7, [str length]-7)];
    
//    [_cityBtn setTitle:(NSString *)str forState:UIControlStateNormal];
    [_cityBtn setAttributedTitle:str forState:UIControlStateNormal];
    [self getServceListWithLon:@"" andLat:@"" andKeyWord:@"" andCityCode:_codeString];
}

-(void)cancleBtnClick {
    [self.pickerView removeFromSuperview];
}
- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark 定位
- (IBAction)LocationBtnCLick:(id)sender {
    [self startLocation];
}
#pragma mark 获取城市列表
-(void)getCityList {
    [SVProgressHUD showWithStatus:@"Loading"];
    
    [[HttpManager getInstance]GetRequest:KGET_CityList params:nil success:^(id responseObj) {
        [SVProgressHUD dismiss];
        if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
            
            _cityListArray = [NSMutableArray array];
            _cityListArray = [responseObj objectForKey:@"Msg"];
            _cityString = [_cityListArray[0] objectForKey:@"CityName"];
            _codeString = [_cityListArray[0]objectForKey:@"CityCode"];
            [_tableView reloadData];
            
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"请求失败"];
            [SVProgressHUD dismissWithDelay:0.5f];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark 搜索 获取服务列表
-(void)getServceListWithLon:(NSString *)lon andLat:(NSString *)Lat andKeyWord:(NSString *)keyWord andCityCode:(NSString *)cityCode {
    
    NSDictionary *dic = @{@"Lon":lon,@"Lat":Lat,@"keyword":keyWord,@"cityCode":cityCode};
    
    [SVProgressHUD showWithStatus:KLoading];
    
    [[HttpManager getInstance]GetRequest:KGET_ServceList params:dic success:^(id responseObj) {
        [SVProgressHUD dismiss];
        if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
            NSArray *array = [responseObj objectForKey:@"Msg"];
            if (array.count ==0) {
                _detailListArray = [NSMutableArray array];
                [_tableView reloadData];
                [SVProgressHUD showInfoWithStatus:@"暂无搜索结果"];
                [SVProgressHUD dismissWithDelay:0.5f];
            }
            else {
                _detailListArray = [NSMutableArray array];
                
                [_detailListArray removeAllObjects];
                
                _detailListArray = [responseObj objectForKey:@"Msg"];
                
                
                [_tableView reloadData];
            }
        }
        else {
            [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
            
        }

    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [_searchBar resignFirstResponder];
    [self getServceListWithLon:@"" andLat:@"" andKeyWord:_searchBar.text andCityCode:@""];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar __TVOS_PROHIBITED {
    NSLog(@"cancle");
    
    [_searchBar resignFirstResponder];
    
}
//隐藏cell多余的分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
- (IBAction)searchBtnClick:(id)sender {
    [self.view addSubview:self.searchView];
    [self.searchBar becomeFirstResponder];
}

-(UIView *)searchView {
    if (!_searchView) {
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        
        _searchView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [cancleBtn setTitle:@"取消" forState:0];
        
        [cancleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [cancleBtn addTarget:self action:@selector(searchBtnCancel) forControlEvents:UIControlEventTouchUpInside];
        
        [cancleBtn setBackgroundColor:RGB(199, 199, 204)];
        
        [cancleBtn setFrame:CGRectMake(SCREEN_WIDTH -55, 20, 55, 40)];
        
        
         _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH-55, 40)];
        
        _searchBar.placeholder = @"搜索";
        
        _searchBar.delegate = self;
        
        [_searchView addSubview:_searchBar];
        
        [_searchView addSubview:cancleBtn];

        
    }
    return _searchView;
}

-(void)searchBtnCancel {
    [self.searchView removeFromSuperview];
}

-(NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
        
    }
    return _imageArray;
}

-(NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [NSMutableArray array];
    }
    return _historyArray;
}

#pragma mark -获取广告轮播图
-(void)getAD_List {
    [[HttpManager getInstance] GetRequest:KGetAD_List params:nil success:^(id responseObj) {
        if ([[responseObj objectForKey:@"ProResult"] isEqualToString:@"0"]) {
            

            [self.imageArray removeAllObjects];
            NSArray *array =[responseObj objectForKey:@"Msg"];
            for (int i =0; i<[array count]; i++) {
                NSString *str = [NSString stringWithFormat:@"%@%@",BaseImageURL,[array[i] objectForKey:@"PhotoUrl"]];
                str = [str stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
                [self.imageArray addObject:str];

            }
//            _bannerScr = [[LCBannerView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 216) delegate:self imageName:[dic objectForKey:@"AdvertName"] count:4 timeInterval:2.0f currentPageIndicatorTintColor:nil pageIndicatorTintColor:nil];
            
            _bannerScr = [[LCBannerView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 216) delegate:self imageURLs:self.imageArray placeholderImageName:@"banner_img" timeInterval:2.0f currentPageIndicatorTintColor:nil pageIndicatorTintColor:nil];
            
            
            [self.view addSubview:_bannerScr];
            
            [self.imageArray removeAllObjects];
            [self.imageArray addObjectsFromArray:array];
        }
        else {
            [SVProgressHUD showInfoWithStatus:[responseObj objectForKey:@"Msg"]];
            [SVProgressHUD dismissWithDelay:1.0f];
        }

    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 获取收藏列表
-(void) getHistory {
    UserModel *user = [UserModel user];
    NSDictionary *dic =@{@"userid":user.userId};
    
    
    
    [[HttpManager getInstance] GetRequest:KGetCollectSysData params:dic success:^(id responseObj) {
        if ([[responseObj objectForKey:@"ProResult"] intValue] ==0) {
            
            [self.historyArray removeAllObjects];
            [self.historyArray addObjectsFromArray:[responseObj objectForKey:@"Msg"]];

            [self setup_history_UI];
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"获取收藏列表失败"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:1.0f];
        
    }];
}
#pragma mark - deleteBtn_Delegate
- (void)deleteButtonRemoveSelf:(DeleteButton *)button{
    
    [self deleteHistoryWithSysID:[self.historyArray[[button tag]] objectForKey:@"SysID"]];
    

}

-(void)btnClick:(DeleteButton *)button{
}
-(void)deleteHistoryWithSysID:(NSString *)sysID {
    
    UserModel *user = [UserModel user];
    NSDictionary *dic =@{@"userid":user.userId,@"SysID":sysID};
    
    [SVProgressHUD showWithStatus:KLoading];
    
    [[HttpManager getInstance] GetRequest:KDeleteCollectSys params:dic success:^(id responseObj) {
        
        if ([[responseObj objectForKey:@"ProResult"] intValue] ==0) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            [SVProgressHUD dismissWithDelay:1.0f];

            for (NSDictionary *dict in self.historyArray) {
                if ([[dict objectForKey:@"SysID"] isEqualToString:sysID]) {
                    [self.historyArray removeObject:dict];
                    break;
                }
            }
            [self setup_history_UI];

            
        }
        else {
            [SVProgressHUD showSuccessWithStatus:@"删除失败"];
            [SVProgressHUD dismissWithDelay:1.0f];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showSuccessWithStatus:error.localizedDescription];
        [SVProgressHUD dismissWithDelay:1.0f];

    }];
}
-(UIView *)backBiew {
    if (!_backBiew) {
        _backBiew = [[UIView alloc]initWithFrame:CGRectMake(0, 320, SCREEN_WIDTH, 50)];
    }
    return _backBiew;
}
-(void)setup_history_UI {
    NSArray *array = [self.backBiew subviews];
    for (UIView *button in array) {
        if ([button isKindOfClass:[DeleteButton class]]) {
            [button removeFromSuperview];
        }
    }
    [self.backBiew removeFromSuperview];
    if (self.historyArray.count ==0) {
        _viewConstraint.constant = 0;

    }
    else {
        _viewConstraint.constant = 50;
        
        self.backBiew.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.backBiew];
        for (int i=0; i<self.historyArray.count; i++) {
            
            DeleteButton *btn= [[DeleteButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/5*i +10, 10, SCREEN_WIDTH/5-10, 30)];
            btn.tag = i;
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[self.historyArray[i] objectForKey:@"SyspointName"] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
            btn.delegate = self;
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setAttributedTitle:string forState:0];

            [self.backBiew addSubview:btn];

        }

        
        
    }

}
@end
