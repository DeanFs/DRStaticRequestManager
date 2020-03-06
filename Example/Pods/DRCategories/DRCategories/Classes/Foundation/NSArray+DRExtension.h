//
//  NSArray+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (DRExtension)

- (id)safeGetObjectWithIndex:(NSInteger)index;

@end


@interface NSMutableArray (DRSafeInsert)

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)safeInsertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes;

@end

NS_ASSUME_NONNULL_END
