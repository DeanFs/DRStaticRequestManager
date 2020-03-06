//
//  DRStaticRequestCache.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import <Foundation/Foundation.h>
#import "DRStaticRequestProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DRStaticRequestCache : NSObject

// 返回接口对应的数据模型数据
+ (id)getStaticRequestDataCacheWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                         params:(id)params;
/**
 直接拿缓存数据，只做json解析，不实例化成数据模型
 
 @param requestClass 请求类
 @param params 请求参数
 @return 当前缓存的jsonObject数据
 */
+ (id)getStaticCacheJsonObjectWithClass:(Class<DRStaticRequestProtocol>)requestClass
                                 params:(id)params;

// 缓存接口请求结果
+ (void)cacheStaticRequestResult:(id)requestResult
                withRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                          params:(id)params;

// 构建缓存key
+ (NSString *)makeCacheKeyWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                    params:(id)params;

// 最新结果与旧的缓存比较
+ (BOOL)isResultData:(id)resultDate equalToCacheData:(id)cacheData;

@end

NS_ASSUME_NONNULL_END
