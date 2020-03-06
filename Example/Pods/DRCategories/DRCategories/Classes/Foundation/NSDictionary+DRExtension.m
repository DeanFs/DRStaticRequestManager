//
//  NSDictionary+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import "NSDictionary+DRExtension.h"

@implementation NSDictionary (DRExtension)

@end


@implementation NSMutableDictionary (DRSafeAccess)

- (void)safeSetObject:(id)object forKey:(id <NSCopying> )key {
    if (object && key) {
        [self setObject:object forKey:key];
    }
}

@end
