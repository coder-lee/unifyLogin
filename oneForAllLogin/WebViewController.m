//
//  WebViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/7/19.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self setNavTitle:_navStr];
    [self setLeftButtonWithImage:[UIImage imageNamed:@"-icon_back"] hImage:nil action:@selector(backBtnClick)];
    
    [SVProgressHUD showWithStatus:KLoading];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    
    [_webView scalesPageToFit];
                                                    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    [SVProgressHUD dismissWithDelay:1.0f];
}

-(void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
