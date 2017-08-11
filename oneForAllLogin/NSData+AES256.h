//
//  NSData+AES256.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/12.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end
