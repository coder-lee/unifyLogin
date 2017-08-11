//
//  HttpManager.m
//  oneForAllLogin
//
//  Created by leo on 2017/6/9.
//  Copyright © 2017年 智行. All rights reserved.
//

#import "HttpManager.h"
#import "AESCipher.h"
#import <CommonCrypto/CommonCryptor.h>

#define K_Sn @"SCHOOLAPP"
#define KAppKey @"fa8cea8e94144887a15d088b0c4b03fb"

#define KSecretKey @"008e2caa320947c68322f28e427e0d11"
@implementation HttpManager


+ (instancetype)getInstance {
    
    static HttpManager* sharedManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedManager = [[HttpManager alloc] init];
    });
    
    return sharedManager;
}

#pragma mark GET
- (void)GetRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    NSLog(@"Url is %@",url);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [dic setValue:[self getKey]forKey:@"sign"];
    [dic setValue:K_Sn forKey:@"sn"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval =30;//超时
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json", @"text/html", nil];
    
//    [manager.requestSerializer setValue:@"text/json" forHTTPHeaderField:@"Content-Type"];


    
    [manager GET:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject is %@",responseObject);
        if (successHandler) {
            successHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            
//            LOG(@"------请求失败-------%@",error);
            NSLog(@"error is %@",error.localizedDescription);
            
            failureHandler(error);
        }
    }];
}

#pragma mark POST
- (void)PostRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [dic setValue:[self getKey] forKey:@"sign"];
    [dic setValue:K_Sn forKey:@"sn"];

    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval =30;//超时
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json", @"text/html", nil];
    
    [manager POST:url parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POST-responseObject is %@",responseObject);
        if (successHandler) {
            successHandler(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            
            LOG(@"------请求失败-------%@",error);
            
            failureHandler(error);
        }
    }];
}
#pragma mark PUT
- (void)PutRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [dic setValue:[self getKey] forKey:@"sign"];
    [dic setValue:K_Sn forKey:@"sn"];


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval =30;//超时
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json", @"text/html", nil];

    [manager PUT:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successHandler) {
            successHandler(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            
            LOG(@"------请求失败-------%@",error);
            
            failureHandler(error);
        }
    }];
}

#pragma mark DELETE
- (void)DeleteRequest:(NSString *)url params:(NSDictionary *)params success:(requestSuccessBlock)successHandler failure:(requestFailureBlock)failureHandler {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    
    [dic setValue:[self getKey] forKey:@"sign"];
    [dic setValue:K_Sn forKey:@"sn"];


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer.timeoutInterval =30;//超时
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json",@"text/json", @"text/html", nil];

    [manager DELETE:url parameters:dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successHandler) {
            successHandler(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureHandler) {
            
            LOG(@"------请求失败-------%@",error);
            
            failureHandler(error);
        }

    }];
    
}

#pragma mark 获取加密key
-(NSString *)getKey {
//    1497249628960  32
    NSString *key = [NSString stringWithFormat:@"%@_%@",KAppKey,[self getTime]];
    
    NSString *string = aesEncryptString(key, KSecretKey);
//    Rsc+vqwCpQP+pSdaZSVehTXcX23YMa8tEAN+5/Rtij8=
    return string;
}
-(NSString *)getTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval timeInterval=[date timeIntervalSince1970]*1000;
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", timeInterval];
    
    return timeString;
}

@end
