//
//  DateView.m
//  StartCloudBoss
//
//  Created by 李伟 on 16/5/11.
//  Copyright © 2016年 Chengdu MoonTeam Technology. All rights reserved.
//

#import "DateView.h"

@implementation DateView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
//    self.alpha = 0.4;
    [super awakeFromNib];
    self.datePicker.maximumDate = [NSDate date];
//    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
}

+(DateView *)instanceDateView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"DateView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
@end
