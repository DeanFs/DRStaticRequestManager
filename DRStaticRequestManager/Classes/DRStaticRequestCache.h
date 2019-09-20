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
// 缓存接口请求结果
+ (void)cacheStaticRequestResult:(id)requestResult
                withRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                          params:(id)params;

// 构建缓存key
+ (NSString *)makeCacheKeyWithRequestClass:(Class<DRStaticRequestProtocol>)requestClass
                                    params:(id)params;

// 最新结果与旧的缓存比较
+ (BOOL)isResultDate:(id)resultDate equalToCacheData:(id)cacheData;

@end

NS_ASSUME_NONNULL_END
