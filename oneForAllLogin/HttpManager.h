//
//  HttpManager.h
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpManager : NSObject




/**
 请求成功block
 */
typedef void (^requestSuccessBlock)(id responseObj);

/**
 请求失败block
 */
typedef void (^requestFailureBlock) (NSError *error);

/**
 请求响应block
 */
typedef void (^responseBlock)(id dataObj, NSError *error);

/**
 监听进度响应block
 */
typedef void (^progressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);


#ifdef DEBUG
#define LOG(...) NSLog(__VA_ARGS__)
#else
#define LOG(...)
#endif

+ (instancetype)getInstance;


/**
 GET 请求

 @param url <#url description#>
 @param params <#params description#>
 @param successHandler <#successHandler description#>
 @param failureHandler <#failureHandler description#>
 */
- (void)GetRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler;


/**
 POST 请求

 @param url <#url description#>
 @param params <#params description#>
 @param successHandler <#successHandler description#>
 @param failureHandler <#failureHandler description#>
 */
- (void)PostRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler;


/**
 PUT 请求

 @param url <#url description#>
 @param params <#params description#>
 @param successHandler <#successHandler description#>
 @param failureHandler <#failureHandler description#>
 */
- (void)PutRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler;


/**
 DELETE 请求

 @param url <#url description#>
 @param params <#params description#>
 @param successHandler <#successHandler description#>
 @param failureHandler <#failureHandler description#>
 */
- (void)DeleteRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler;



@end
