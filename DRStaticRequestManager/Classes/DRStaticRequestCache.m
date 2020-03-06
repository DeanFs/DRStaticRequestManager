//
//  DRStaticRequestCache.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import "DRStaticRequestCache.h"
#import <DRSandboxManager/DRSandboxManager.h>
#import <YYModel/YYModel.h>

@implementation DRStaticRequestCache

+ (NSString *)staticRequestCacheFilePathWithKey:(NSString *)key {
    __block NSString *cachePath;
    NSString *fileName = [NSString stringWithFormat:@"%@.json", key];
    [DRSandBoxManager getFilePathWithName:fileName
                                    inDir:@"DRBasicKit/StaticRequestCacheFile"
                                doneBlock:^(NSError * _Nonnull error, NSString * _Nonnull filePath) {
                                    if (!error && filePath) {
                                        cachePath = filePath;
                                    }
                                }];
    return cachePath;
}

+ (id)getStaticRequestDataCacheWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                         params:(id)params {
    if (![requestClass respondsToSelector:@selector(packageToModel:params:)]) {
        NSString *message = [NSString stringWithFormat:@"%@请求类未遵循DRStaticRequestProtocol协议，实现packageToModel:params:方法", NSStringFromClass(requestClass)];
        NSAssert(NO, message);
        return nil;
    }
    
    id jsonObject = [self getStaticCacheJsonObjectWithClass:requestClass params:params];
    if (jsonObject != nil) {
        return [requestClass packageToModel:jsonObject params:params];
    }
    return nil;
}

/**
 直接拿缓存数据，只做json解析，不实例化成数据模型
 
 @param requestClass 请求类
 @param params 请求参数
 @return 当前缓存的jsonObject数据
 */
+ (id)getStaticCacheJsonObjectWithClass:(Class<DRStaticRequestProtocol>)requestClass
                                 params:(id)params {
    NSString *key = [self makeCacheKeyWithRequestClass:requestClass params:params];
    // 先读沙盒缓存
    NSData *data = [NSData dataWithContentsOfFile:[self staticRequestCacheFilePathWithKey:key]];
    if (data == nil) {
        // 没有缓存则尝试读本地json
        if ([requestClass respondsToSelector:@selector(localJsonDataFromParams:)]) {
            data = [requestClass localJsonDataFromParams:params];
        } else {
            // 默认json文件，于请求类同名
            NSString *jsonPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(requestClass)
                                                                 ofType:@"json"];
            data = [NSData dataWithContentsOfFile:jsonPath];
        }
    }
    if (data != nil) {
        return [self jsonResultFromJsonData:data
                           withRequestClass:requestClass
                                     params:params];
    }
    return nil;
}

+ (void)cacheStaticRequestResult:(id)requestResult
                withRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                          params:(id)params {
    if (requestResult != nil) {
        NSString *key = [self makeCacheKeyWithRequestClass:requestClass params:params];
        NSData *data = [requestResult yy_modelToJSONData];
        [data writeToFile:[self staticRequestCacheFilePathWithKey:key]
               atomically:YES];
    }
}

+ (id)jsonResultFromJsonData:(NSData *)jsonData
            withRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                      params:(id)params {
    id result;
    if (jsonData != nil) {
        result = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if ([requestClass respondsToSelector:@selector(checkDataFomat:params:)]) {
            if (![requestClass checkDataFomat:result params:params]) {
                result = nil;
            }
        }
    }
    return result;
}

+ (NSString *)makeCacheKeyWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass params:(id)params {
    if ([requestClass respondsToSelector:@selector(cacheKeyFromParams:)]) {
        return [requestClass cacheKeyFromParams:params];
    }
    NSString *cachePath = NSStringFromClass(requestClass);
    if (params) {
        if ([params isKindOfClass:[NSString class]] ||
            [params isKindOfClass:[NSNumber class]]) {
            cachePath = [NSString stringWithFormat:@"%@_%@", cachePath, params];
        } else {
            NSString *paramString = [params yy_modelToJSONString];
            cachePath = [NSString stringWithFormat:@"%@_%@", cachePath, paramString];
        }
    }
    return cachePath;
}

+ (BOOL)isResultData:(id)resultData equalToCacheData:(id)cacheData {
    return [[resultData yy_modelToJSONData] isEqualToData:[cacheData yy_modelToJSONData]];
}

@end
