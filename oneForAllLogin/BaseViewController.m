//
//  BaseViewController.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "BaseViewController.h"




@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (IOS7_OR_LATER) {
                self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    //设置背景颜色
    //
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0000000"]];
    //    imageView.frame = self.view.bounds;
    //
    //    [self.view insertSubview:imageView atIndex:0];
    
    
    //设置背景颜色
    [self.view setBackgroundColor:RGB(240, 240, 240)];
    
    self.navigationController.navigationBar.barTintColor = RGB(19, 222, 105);

}

/**********************************************************************/
#pragma mark - Public Methods
/**********************************************************************/





- (void)shake:(UITextField *)label {
    
    //    label.transform = CGAffineTransformIdentity;
    //    [UIView beginAnimations:nil context:nil];//动画的开始
    //    [UIView setAnimationDuration:0.05];//完成时间
    //    [UIView setAnimationRepeatCount:3];//重复
    //    [UIView setAnimationRepeatAutoreverses:YES];//往返运动
    //    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];//控制速度变化
    //    label.transform = CGAffineTransformMakeTranslation(-5, 0);//设置横纵坐标的移动
    //    [UIView commitAnimations];//动画结束
    
    CAKeyframeAnimation *keyAn = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyAn setDuration:0.5f];
    NSArray *array = [[NSArray alloc] initWithObjects:
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x-5, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x+5, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x-5, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x+5, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x-5, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x+5, label.center.y)],
                      [NSValue valueWithCGPoint:CGPointMake(label.center.x, label.center.y)],
                      nil];
    [keyAn setValues:array];
    
    NSArray *times = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithFloat:0.1f],
                      [NSNumber numberWithFloat:0.2f],
                      [NSNumber numberWithFloat:0.3f],
                      [NSNumber numberWithFloat:0.4f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.6f],
                      [NSNumber numberWithFloat:0.7f],
                      [NSNumber numberWithFloat:0.8f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f],
                      nil];
    [keyAn setKeyTimes:times];
    [label.layer addAnimation:keyAn forKey:@"Shark"];
}
@end
