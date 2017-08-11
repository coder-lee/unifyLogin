//
//  UIViewController+Nav.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Nav)
/**
 设置nav背景
 
 @param image <#image description#>
 @param color <#color description#>
 @param backImage <#backImage description#>
 @param backhlImage <#backhlImage description#>
 */
- (void)setNavbarBgImage:(UIImage *)image titleColor:(UIColor *)color backImage:(NSString *)backImage backhlImage:(NSString *)backhlImage;


/**
 在nav创建一个segment
 
 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param selectIndex <#selectIndex description#>
 @param action <#action description#>
 */
- (void)setTitle:(NSString *)title
        subTitle:(NSString *)subTitle
   selectAtIndex:(NSInteger)selectIndex
          action:(SEL)action;

/**
 设置nav title img

 @param titleUrl <#titleUrl description#>
 */
- (void)setTitleImage:(NSString *)titleUrl;


/**
 设置nav title

 @param title <#title description#>
 */
- (void)setNavTitle:(NSString *)title;


/**
 添加搜索

 @param ptitle <#ptitle description#>
 @param action <#action description#>
 */
- (void)setSearchWithPTitle:(NSString *)ptitle
                     action:(SEL)action;


/**
 设置标题

 @param title <#title description#>
 @param subTitle <#subTitle description#>
 @param imgUrl <#imgUrl description#>
 @param action <#action description#>
 */
- (void)setTitle:(NSString *)title
        subTitle:(NSString *)subTitle
       iconImage:(NSString *)imgUrl
          action:(SEL)action;


/**
 设置返回（系统）title

 @param title <#title description#>
 */
- (void)setBackButtonWithTitle:(NSString *)title;


/**
 设置左边按钮

 @param title <#title description#>
 @param action <#action description#>
 */
- (void)setLeftButtonWithTitle:(NSString *)title
                        action:(SEL)action;

/**
 设置左边按钮  img

 @param image <#image description#>
 @param hImage <#hImage description#>
 @param action <#action description#>
 */
- (void)setLeftButtonWithImage:(UIImage *)image
                        hImage:(UIImage *)hImage
                        action:(SEL)action;

/**
 设置左边按钮（2个）

 @param oneTitle <#oneTitle description#>
 @param secondTitle <#secondTitle description#>
 @param image <#image description#>
 @param hImage <#hImage description#>
 @param oneAction <#oneAction description#>
 @param secondAction <#secondAction description#>
 */
- (void)setLeftButtonOneTitle:(NSString *)oneTitle
                   seconTitle:(NSString *)secondTitle
                        image:(UIImage *)image
                       himage:(UIImage *)hImage
                    oneAction:(SEL)oneAction
                 secondAction:(SEL)secondAction;

/**
 设置左边按钮

 @param title <#title description#>
 @param image <#image description#>
 @param hImage <#hImage description#>
 @param action <#action description#>
 */
- (void)setLeftButtonWithTitle:(NSString *)title
                         image:(UIImage *)image
                        himage:(UIImage *)hImage
                        action:(SEL)action;


/**
 设置右边按钮

 @param title <#title description#>
 @param action <#action description#>
 */
- (void)setRightButtonWithTitle:(NSString *)title
                         action:(SEL)action;
- (void)setRightButtonWithImage:(UIImage *)image
                         hImage:(UIImage *)hImage
                         action:(SEL)action;
- (void)setRightButtonWithImage:(UIImage *)image
                         hImage:(UIImage *)hImage
                         action:(SEL)action
                       subImage:(UIImage *)subImage
                      subhImage:(UIImage *)subHImage
                      subAction:(SEL)subAction;


@end
