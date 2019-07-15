//
//  DRStaticRequestCache.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRStaticRequestCache : NSObject

+ (NSData *)getStaticRequestDataCacheForKey:(NSString *)key;
+ (void)cacheStaticRequestData:(NSData *)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
