//
//  UIViewController+Nav.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "UIViewController+Nav.h"
#import "MarqueeLabel.h"
@implementation UIViewController (Nav)
- (void)setTitle:(NSString *)title
        subTitle:(NSString *)subTitle
   selectAtIndex:(NSInteger)selectIndex
          action:(SEL)action{
    
    CGRect frame = CGRectMake(0, 0, 150, 44);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setTag:59123];
    [view setBackgroundColor:[UIColor clearColor]];
    
    UISegmentedControl *segmentedControl = (UISegmentedControl *)[view viewWithTag:10001];
    
    if(segmentedControl == nil){
        segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0, 8.0, 150.0, 30.0)];
        [segmentedControl setTag:10001];
        segmentedControl.selectedSegmentIndex = 2;//设置默认选择项索引
        segmentedControl.tintColor = [UIColor whiteColor];
        
        [view addSubview:segmentedControl];
        
    }
    
    [segmentedControl insertSegmentWithTitle:title atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithTitle:subTitle atIndex:1 animated:NO];
    segmentedControl.selectedSegmentIndex = selectIndex;
    [segmentedControl addTarget:self action:action forControlEvents:UIControlEventValueChanged];
    
    [self.navigationItem setTitleView:view];
}


- (void)setTitleImage:(NSString *)titleUrl{
    
    UIImage *navImage = [UIImage imageNamed:titleUrl];
    
    UIView *titleView = [[UIView alloc] init];
    [titleView setFrame:CGRectMake(0,0, navImage.size.width, navImage.size.height)];
    
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:navImage];
    [iconView setContentMode:UIViewContentModeCenter];
    [iconView setFrame:CGRectMake(0, -3, navImage.size.width, navImage.size.height)];
    
    [titleView addSubview:iconView];
    
    [self.navigationItem setTitleView:titleView];
    
}

- (void)setSearchWithPTitle:(NSString *)ptitle
                     action:(SEL)action{
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width*(260.0f/320.0f), 44);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setTag:59123];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:view];
    
    UIView *bgView = (UIView *)[view viewWithTag:10004];
    
    if(bgView == nil){
        bgView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width*(20.0f/320.0f), 7,self.view.frame.size.width*(260.0f/320.0f), 30)];
        [bgView setTag:10004];
        [bgView setBackgroundColor:RGBA(0, 0, 0, 0.15)];
        bgView.layer.cornerRadius = 3;
        [view addSubview:bgView];
    }
    
    UIImageView *iconView = (UIImageView *)[view viewWithTag:10005];
    
    if(iconView == nil){
        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_icon_search"]];
        [iconView setFrame:CGRectMake(-self.view.frame.size.width*(20.0f/320.0f)+ 5,12, 20, 20)];
        [iconView setTag:10004];
        [iconView setContentMode:UIViewContentModeCenter];
        [view addSubview:iconView];
    }
    
    
    UILabel *titleLabel = (UILabel *)[view viewWithTag:10001];
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] init];
        [titleLabel setTag:10001];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentLeft];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:17]];
        [view addSubview:titleLabel];
        
    }
    [titleLabel setFrame:CGRectMake(-self.view.frame.size.width*(20.0f/320.0f) + 28, 12, 100, 20)];
    [titleLabel setText:ptitle];
    
    UIButton *button = (UIButton *)[view viewWithTag:10003];
    if (button == nil) {
        button = [[UIButton alloc] init];
        [button setTag:10003];
        [view addSubview:button];
    }
    [button setFrame:frame];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setNavTitle:(NSString *)title{
    [self setNavTitle:title textColor:RGB(255, 255, 255)];
}

- (void)setNavTitle:(NSString *)title textColor:(UIColor *)color{
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:20] byHeight:44];
    
    CGRect frame = CGRectZero;
    
    if(size.width > SCREEN_WIDTH*0.6){
        frame = CGRectMake(0, 0, SCREEN_WIDTH*0.6, 44);
    }else{
        frame = CGRectMake(0, 0, size.width, 44);
    }
    
    
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setTag:59123];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:view];
    
    MarqueeLabel *titleLabel = (MarqueeLabel *)[view viewWithTag:10001];
    if (titleLabel == nil) {
        titleLabel = [[MarqueeLabel alloc] init];
        [titleLabel setTag:10001];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:color];
        [titleLabel setFont:[UIFont systemFontOfSize:20]];
        titleLabel.scrollDuration = 5.0f;
        titleLabel.fadeLength = 5.0f;
        titleLabel.trailingBuffer = 30.0f;
        
        [view addSubview:titleLabel];
        
    }
    [titleLabel setFrame:frame];
    [titleLabel setText:title];
}

//设置标题
- (void)setTitle:(NSString *)title
        subTitle:(NSString *)subTitle
       iconImage:(NSString *)imgUrl
          action:(SEL)action{
    UIFont *titleFont = [UIFont boldSystemFontOfSize:15];
    UIFont *subTitleFont = [UIFont boldSystemFontOfSize:12];
    CGSize titleSize = [title sizeWithFont:titleFont byHeight:24];
    CGSize subTitleSize = [subTitle sizeWithFont:subTitleFont byHeight:16];
    CGFloat width = titleSize.width>subTitleSize.width?titleSize.width:subTitleSize.width;
    CGRect frame = CGRectMake(0, 0, width<44?44:width, 44);
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setTag:59123];
    [view setBackgroundColor:[UIColor clearColor]];
    [self.navigationItem setTitleView:view];
    
    
    UILabel *titleLabel = (UILabel *)[view viewWithTag:10001];
    if (titleLabel == nil) {
        titleLabel = [[UILabel alloc] init];
        [titleLabel setTag:10001];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setFont:titleFont];
        [view addSubview:titleLabel];
        
    }
    [titleLabel setFrame:CGRectMake(0, 6, frame.size.width, 24)];
    [titleLabel setText:title];
    
    UILabel *subTitleLabel = (UILabel *)[view viewWithTag:10002];
    if (subTitleLabel == nil) {
        subTitleLabel = [[UILabel alloc] init];
        [subTitleLabel setTag:10002];
        [subTitleLabel setBackgroundColor:[UIColor clearColor]];
        [subTitleLabel setTextAlignment:NSTextAlignmentCenter];
        [subTitleLabel setTextColor:[UIColor whiteColor]];
        [subTitleLabel setFont:subTitleFont];
        [view addSubview:subTitleLabel];
        
    }
    [subTitleLabel setFrame:CGRectMake(0, 26, frame.size.width, 16)];
    [subTitleLabel setText:subTitle];
    
    UIImageView *iconView = (UIImageView *)[view viewWithTag:10004];
    
    if(iconView == nil){
        iconView = [[UIImageView alloc] init];
        [iconView setTag:10004];
        [iconView setContentMode:UIViewContentModeCenter];
        [view addSubview:iconView];
    }
    
    [iconView setImage:[UIImage imageNamed:imgUrl]];
    [iconView setFrame:CGRectMake(titleLabel.frame.origin.x+frame.size.width, 10, 20, 24)];
    
    
    UIButton *button = (UIButton *)[view viewWithTag:10003];
    if (button == nil) {
        button = [[UIButton alloc] init];
        [button setTag:10003];
        [view addSubview:button];
    }
    [button setFrame:frame];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
}



//设置（系统）返回
- (void)setBackButtonWithTitle:(NSString *)title{
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc]
                                   initWithTitle:title
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:nil];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setBackBarButtonItem:buttonItem];
}


//设置NavBar背景
- (void)setNavbarBgImage:(UIImage *)image titleColor:(UIColor *)color backImage:(NSString *)backImage backhlImage:(NSString *)backhlImage{
    UINavigationBar *bar = self.navigationController.navigationBar;
    if ([bar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        
        //设置NavBar文字样式
        [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                      NSForegroundColorAttributeName: color,
                                      NSStrokeWidthAttributeName: [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)],
                                      NSStrokeColorAttributeName: color}];
    }
    
    [self setLeftButtonWithImage:[UIImage imageNamed:backImage]
                          hImage:[UIImage imageNamed:backhlImage]
                          action:@selector(bsBackAction)];
}

//设置左边按钮
- (void)setLeftButtonWithTitle:(NSString *)title
                        action:(SEL)action{
    UIFont *font = [UIFont boldSystemFontOfSize:15];
    CGSize size = [title sizeWithFont:font byHeight:44];
    CGRect frame = CGRectMake(0, 0, size.width<44?44:size.width, 44);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button.titleLabel setFont:font];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    if (!IOS7_OR_LATER) {
        frame.size.width += 10;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button setFrame:frame];
    }
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
    
}

//设置左边按钮(关闭)
- (void)setLeftButtonOneTitle:(NSString *)oneTitle
                   seconTitle:(NSString *)secondTitle
                        image:(UIImage *)image
                       himage:(UIImage *)hImage
                    oneAction:(SEL)oneAction
                 secondAction:(SEL)secondAction{
    
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = [oneTitle sizeWithFont:font byHeight:44];
    CGRect frame = CGRectMake(0, 0, size.width<44?44:size.width, 44);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button.titleLabel setFont:font];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hImage forState:UIControlStateHighlighted];
    [button setTitle:oneTitle forState:UIControlStateNormal];
    [button setTitle:oneTitle forState:UIControlStateHighlighted];
    [button addTarget:self action:oneAction forControlEvents:UIControlEventTouchUpInside];
    
    
    UIFont *font1 = [UIFont systemFontOfSize:14];
    CGSize size1 = [secondTitle sizeWithFont:font1 byHeight:44];
    CGRect frame1 = CGRectMake(0, 0, size1.width<44?44:size1.width, 44);
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame1.size.width, frame.size.height)];
    [button1.titleLabel setFont:font1];
    [button1 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button1.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button1 setTitle:secondTitle forState:UIControlStateNormal];
    [button1 setTitle:secondTitle forState:UIControlStateHighlighted];
    [button1 addTarget:self action:secondAction forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [view addSubview:button];
    [view setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.origin.y, frame1.size.width, frame1.size.height)];
    [view1 setBackgroundColor:[UIColor clearColor]];
    [view1 addSubview:button1];
    UIBarButtonItem *buttonItem1 = [[UIBarButtonItem alloc] initWithCustomView:view1];
    [buttonItem1 setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:buttonItem,buttonItem1, nil]];
    
    
    
    
}


//设置左边按钮
- (void)setLeftButtonWithTitle:(NSString *)title
                         image:(UIImage *)image
                        himage:(UIImage *)hImage
                        action:(SEL)action{
    //    CGSize size = image.size;
    CGRect frame = CGRectMake(0, 0, 80, 44);
    UIFont *font = [UIFont systemFontOfSize:14];
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button.titleLabel setFont:font];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hImage forState:UIControlStateHighlighted];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
}

- (void)setLeftButtonWithImage:(UIImage *)image
                        hImage:(UIImage *)hImage
                        action:(SEL)action{
    CGSize size = image.size;
    CGRect frame = CGRectMake(-2, 0, size.width<44?44:size.width, 44);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hImage forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setLeftBarButtonItem:buttonItem];
    
}

//设置右边按钮
- (void)setRightButtonWithTitle:(NSString *)title
                         action:(SEL)action{
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = [title sizeWithFont:font byHeight:44];
    CGRect frame = CGRectMake(0, 0, size.width<44?44:size.width, 44);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button.titleLabel setFont:font];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]  forState:UIControlStateHighlighted];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setRightBarButtonItem:buttonItem];
}
- (void)setRightButtonWithImage:(UIImage *)image
                         hImage:(UIImage *)hImage
                         action:(SEL)action{
    CGSize size = image.size;
    CGRect frame = CGRectMake(2, 0, size.width<44?44:size.width, 44);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hImage forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setRightBarButtonItem:buttonItem];
    
}

- (void)setRightButtonWithImage:(UIImage *)image
                         hImage:(UIImage *)hImage
                         action:(SEL)action
                       subImage:(UIImage *)subImage
                      subhImage:(UIImage *)subHImage
                      subAction:(SEL)subAction{
    CGSize size = image.size;
    CGRect frame = CGRectMake(10, 0, size.width<44?44:size.width, 44);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:hImage forState:UIControlStateHighlighted];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    if (!IOS7_OR_LATER) {
        frame.size.width += 10;
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [button setFrame:frame];
    }
    
    frame.origin.x = frame.origin.x + button.frame.size.width - 10;
    
    UIButton *subButton = [[UIButton alloc] initWithFrame:frame];
    [subButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [subButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [subButton setImage:subImage forState:UIControlStateNormal];
    [subButton setImage:subHImage forState:UIControlStateHighlighted];
    [subButton addTarget:self action:subAction forControlEvents:UIControlEventTouchUpInside];
    
    frame.size.width = frame.size.width*2;
    UIView *contentView = [[UIView alloc] initWithFrame:frame];
    [contentView setBackgroundColor:[UIColor clearColor]];
    
    [contentView addSubview:button];
    [contentView addSubview:subButton];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:contentView];
    [buttonItem setBackgroundVerticalPositionAdjustment:0.0f forBarMetrics:UIBarMetricsDefault];
    [self.navigationItem setRightBarButtonItem:buttonItem];
    
}


@end
