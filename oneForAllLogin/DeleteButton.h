//
//  DeleteButton.h
//  oneForAllLogin
//
//  Created by leo on 2017/7/18.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DeleteButton;
@protocol DeleteButtonDelegate <NSObject>
@optional
- (void)deleteButtonRemoveSelf:(DeleteButton *)button;
@end



@interface DeleteButton : UIButton
@property (nonatomic, weak) id<DeleteButtonDelegate> delegate;

@end
