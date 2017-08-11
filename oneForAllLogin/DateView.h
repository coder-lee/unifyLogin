//
//  DateView.h
//  StartCloudBoss
//
//  Created by 李伟 on 16/5/11.
//  Copyright © 2016年 Chengdu MoonTeam Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateView : UIView
{
    
}
+(DateView *)instanceDateView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *backBiew;
@end
