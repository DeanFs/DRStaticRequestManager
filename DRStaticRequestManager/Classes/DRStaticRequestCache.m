//
//  DRStaticRequestCache.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import "DRStaticRequestCache.h"
#import <DRSandboxManager/DRSandboxManager.h>

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

+ (NSData *)getStaticRequestDataCacheForKey:(NSString *)key {
    return [NSData dataWithContentsOfFile:[self staticRequestCacheFilePathWithKey:key]];;
}

+ (void)cacheStaticRequestData:(NSData *)data forKey:(NSString *)key {
    if (data) {
        [data writeToFile:[self staticRequestCacheFilePathWithKey:key]
               atomically:YES];
    }
}

@end
