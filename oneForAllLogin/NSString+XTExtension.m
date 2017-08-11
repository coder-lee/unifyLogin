//
//  NSString+XTExtension.m
//  XTFramework
//
//  Created by Qing Xiubin on 13-8-15.
//  Copyright (c) 2013年 XT. All rights reserved.
//

#import "NSString+XTExtension.h"
#import <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation NSString (XTString)

+ (NSString *)UUID{
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
    CFRelease(uuidRef);
    
    NSString *uuidString = [(__bridge NSString *)stringRef lowercaseString];
    CFRelease(stringRef);
    
    return uuidString;
}

+ (NSString *)mechineID{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *mechineID = [userInfo objectForKey:@"mechineID"];
    if (mechineID == nil) {
        mechineID = [NSString UUID];
        [userInfo setObject:mechineID forKey:@"mechineID"];
        [userInfo synchronize];
    }
    
    return mechineID;
}

+ (NSString *)uniqueID{
    NSUserDefaults *userInfo = [NSUserDefaults standardUserDefaults];
    
    NSString *uniqueID = [userInfo objectForKey:@"uniqueID"];
    if (uniqueID == nil) {
        uniqueID = [@"IOS" stringByAppendingString:[[self UUID] md5Digest]];
        [userInfo setObject:uniqueID forKey:@"uniqueID"];
        [userInfo synchronize];
    }
    
    return uniqueID;
}

+ (NSString *)randomString:(NSUInteger)length{
    char data[length];
    for (int x=0;x<length;data[x++] = (char)('a' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:length encoding:NSUTF8StringEncoding];
}

- (NSString *)URLEncodedString
{
    NSString * outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             NULL,
                                                                             (__bridge CFStringRef)self,
                                                                             NULL,
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             kCFStringEncodingUTF8);
    return outputStr;
}

@end


@implementation NSString (XTDigest)

- (NSString *)md5Digest{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    return hash;
}


- (NSString *)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

- (NSString *)sha1Digest{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(cStr, (CC_LONG)strlen(cStr), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [hash appendFormat:@"%02x", result[i]];
    }
    
    return hash;
}


- (NSString *)hmacSha1Digest:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cStr = [self UTF8String];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cStr, strlen(cStr), cHMAC);
    
    NSString *hash;
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", cHMAC[i]];
    }
    
    hash = output;
    
    return hash;
}

- (NSString*)hmacSha256Digest:(NSString *)key{
    const char *cKey = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [self UTF8String];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hash = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hashString = [hash description];
    
    hashString = [hashString stringByReplacingOccurrencesOfString:@" " withString:@""];
    hashString = [hashString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hashString = [hashString stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    return hashString;
}

- (NSString *)hmacMD5Digest:(NSString *)key{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [self cStringUsingEncoding:NSUTF8StringEncoding];
    const unsigned int blockSize = 64;
    char ipad[blockSize];
    char opad[blockSize];
    char keypad[blockSize];
    
    unsigned long keyLen = strlen(cKey);
    CC_MD5_CTX ctxt;
    if (keyLen > blockSize) {
        CC_MD5_Init(&ctxt);
        CC_MD5_Update(&ctxt, cKey, (CC_LONG)keyLen);
        CC_MD5_Final((unsigned char *)keypad, &ctxt);
        keyLen = CC_MD5_DIGEST_LENGTH;
    }
    else {
        memcpy(keypad, cKey, keyLen);
    }
    
    memset(ipad, 0x36, blockSize);
    memset(opad, 0x5c, blockSize);
    
    int i;
    for (i = 0; i < keyLen; i++) {
        ipad[i] ^= keypad[i];
        opad[i] ^= keypad[i];
    }
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, ipad, blockSize);
    CC_MD5_Update(&ctxt, cData, (CC_LONG)strlen(cData));
    unsigned char md5[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(md5, &ctxt);
    
    CC_MD5_Init(&ctxt);
    CC_MD5_Update(&ctxt, opad, blockSize);
    CC_MD5_Update(&ctxt, md5, CC_MD5_DIGEST_LENGTH);
    CC_MD5_Final(md5, &ctxt);
    
    const unsigned int hex_len = CC_MD5_DIGEST_LENGTH*2+2;
    char hex[hex_len];
    for(i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        snprintf(&hex[i*2], hex_len-i*2, "%02x", md5[i]);
    }
    
    NSData *HMAC = [[NSData alloc] initWithBytes:hex length:strlen(hex)];
    NSString *hash = [[NSString alloc] initWithData:HMAC encoding:NSUTF8StringEncoding];

    return hash;
}

- (NSString *)cutCom{
    
    if(self.length > 0){
        NSArray *urlArray =  [self componentsSeparatedByString:@"|"];
        
        NSString *finalUrl = nil;
        
        NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@".*(.com)[^/]*"
                                                                                        options:0
                                                                                          error:nil];
        for(NSString *url in urlArray){
            NSArray* match = [regularExpretion matchesInString:url options:NSMatchingReportCompletion range:NSMakeRange(0, [url length])];
            
            if (match.count != 0)
            {
                for (NSTextCheckingResult *matc in match)
                {
                    NSRange range = [matc range];
                    
                    if(finalUrl == nil){
                        finalUrl = [url substringFromIndex:range.length];
                    }else{
                        finalUrl = [finalUrl stringByAppendingFormat:@"|%@",[url substringFromIndex:range.length]];
                    }
                    
                }
            }
        }
        
        return finalUrl;
    }
    
    return nil;
}

@end


@implementation NSString (XTJson)

//- (id)objectFromJSONString{
//    return [[self dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONData];
//}
//- (id)objectFromJSONStringWithoutNull{
//    return [[self dataUsingEncoding:NSUTF8StringEncoding] objectFromJSONDataWithoutNull];
//}

@end


@implementation NSString (XTDate)

static NSDateFormatter *dateFormatter = nil;
- (NSDate *)dateWithFormate:(NSString *)formate{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:formate];
    return [dateFormatter dateFromString:self];
}

@end


@implementation NSString (XTRegex)

- (BOOL)match:(NSString *)expression{
	NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
	if ( nil == regex ){
		return NO;
    }
	
	NSUInteger numberOfMatches = [regex numberOfMatchesInString:self
                                                        options:0
                                                          range:NSMakeRange(0, self.length)];
	if ( 0 == numberOfMatches ){
		return NO;
    }
    
	return YES;
}

- (BOOL)matchAnyOf:(NSArray *)array{
	for ( NSString * str in array ){
		if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] ){
			return YES;
		}
	}
	return NO;
}

- (BOOL)isNumberOfDecimal:(NSUInteger)length{
    NSString *tempString = self;
    if (![tempString match:@"^[.0-9]+$"]) {
        return NO;
    }
    if ([tempString hasPrefix:@"00"]) {
        return NO;
    }
    NSRange tempRange = [tempString rangeOfString:@"."];
    if (tempRange.location!=NSNotFound) {
        tempString = [tempString substringFromIndex:tempRange.location+1];
        if (tempString.length>length) {
            return NO;
        }
        tempRange = [tempString rangeOfString:@"."];
        if (tempRange.location!=NSNotFound) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)isTelephone{
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Telephone];
	return [pred evaluateWithObject:self];
}

- (BOOL)isIdCard{
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_IDCard];
    return [pred evaluateWithObject:self];
}

- (BOOL)isMobilphone{
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Mobilephone];
	return [pred evaluateWithObject:self];
}

- (BOOL)isMobilphoneCode{
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_MobilephoneCoede];
    return [pred evaluateWithObject:self];
}
- (BOOL)isPhone{
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Phone];
    return [pred evaluateWithObject:self];
}
- (BOOL)isUserName{
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_UserName];
	return [pred evaluateWithObject:self];
}

- (BOOL)isPassword{
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Password];
	return [pred evaluateWithObject:self];
}

- (BOOL)isEmail{
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Email];
	return [pred evaluateWithObject:self];
}

- (BOOL)isUrl{
	NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex_Url];
	return [pred evaluateWithObject:self];
}

@end


@implementation NSString (XTSize)

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width{

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
	return CGSizeMake((int)size.width+1,(int)size.height+1);
    
//    CGSize size = [self sizeWithFont:font
//                   constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
//                       lineBreakMode:NSLineBreakByWordWrapping];
//    return CGSizeMake((int)size.width+1,(int)size.height);
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil].size;
    return CGSizeMake((int)size.width+1,(int)size.height+1);
}

-(NSString*)TimeformatFromSeconds:(NSInteger)seconds
{
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    return format_time;
}
@end
