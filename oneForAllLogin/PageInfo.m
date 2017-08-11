//
//  PageInfo.m
//  smartCampus
//
//  Created by witaction on 2017/5/3.
//  Copyright © 2017年 witaction. All rights reserved.
//

#import "PageInfo.h"
#import "ChooseViewController.h"


#import "TabbarViewController.h"
#import "YYKit.h"
@implementation PageInfo

+(UITabBarController *)instanceTabbarController {
    NSMutableArray *controllers             = [NSMutableArray array];

    NSArray *pages                          = [self pages];

    UIViewController *pageController        = nil;

    UINavigationController *navPage         = nil;

    UIStoryboard *tabbarStoryBoard          = [UIStoryboard storyboardWithName:@"Login" bundle:nil];

    TabbarViewController *rootTabbar    = [tabbarStoryBoard instantiateViewControllerWithIdentifier:@"TabbarViewController"];

    for (PageInfo *pageInfo in pages ) {
    pageController                          = [tabbarStoryBoard instantiateViewControllerWithIdentifier:pageInfo.ClassName];
        
    navPage                                 = [[UINavigationController alloc] initWithRootViewController:pageController];
        
    pageController.tabBarItem.image         = [UIImage imageNamed:pageInfo.Image];
        
    pageController.tabBarItem.title         = pageInfo.Title;
        
    
    pageController.tabBarItem.selectedImage = [UIImage imageNamed:pageInfo.SelectImage];
                pageController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
        [controllers addObject:navPage];
    }

    rootTabbar.viewControllers              = controllers;

    return rootTabbar;


}

+(NSArray *)pages
{
    NSString *configFile                    = [[NSBundle mainBundle] pathForResource:@"Tabbar" ofType:@"plist"];
    
    NSArray *pageConfigs                    = [NSArray arrayWithContentsOfFile:configFile];
    
    NSMutableArray *pages                   = [[NSMutableArray alloc] init];

    if (pageConfigs.count <= 0) {
        
//        BASE_ERROR_FUN(@"没有配置TabBarPages.plist");
    }

    for (NSDictionary *dict in pageConfigs) {
    PageInfo *info                          = [PageInfo modelWithDictionary:dict];
        [pages addObject:info];
    }

    return pages;
}
@end
