//
//  NSDictionary+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (DRExtension)

@end


@interface NSMutableDictionary (DRSafeAccess)

- (void)safeSetObject:(id)object forKey:(id <NSCopying> )key;

@end

NS_ASSUME_NONNULL_END
