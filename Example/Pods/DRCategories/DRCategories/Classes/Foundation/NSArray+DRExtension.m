//
//  NSArray+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/6.
//

#import "NSArray+DRExtension.h"
#import "NSObject+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>

@implementation NSArray (DRExtension)

+ (void)load {
    @autoreleasepool {
        [objc_getClass("__NSArray0") swizzleOriginSelector:@selector(objectAtIndex:)
                                                 targetSel:@selector(emptyObjectIndex:)];
        [objc_getClass("__NSSingleObjectArrayI") swizzleOriginSelector:@selector(objectAtIndex:)
                                                             targetSel:@selector(WG_objectAtIndex_NSSingleObjectArrayI:)];
        [objc_getClass("__NSArrayI") swizzleOriginSelector:@selector(objectAtIndex:)
                                                 targetSel:@selector(arrObjectIndex:)];
        [objc_getClass("__NSArrayI") swizzleOriginSelector:@selector(objectAtIndexedSubscript:)
                                                 targetSel:@selector(arrayI_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") swizzleOriginSelector:@selector(objectAtIndex:)
                                                 targetSel:@selector(mutableObjectIndex:)];
        [objc_getClass("__NSFrozenArrayM") swizzleOriginSelector:@selector(objectAtIndexedSubscript:)
                                                       targetSel:@selector(arrayF_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") swizzleOriginSelector:@selector(objectAtIndexedSubscript:)
                                                 targetSel:@selector(sw_objectAtIndexedSubscript:)];
        [objc_getClass("__NSArrayM") swizzleOriginSelector:@selector(insertObject:atIndex:)
                                                 targetSel:@selector(mutableInsertObject:atIndex:)];
        [objc_getClass("__NSArrayM") swizzleOriginSelector:@selector(setObject:atIndexedSubscript:)
                                                 targetSel:@selector(sw_setObject:atIndexedSubscript:)];
    }
}

- (id)emptyObjectIndex:(NSInteger)index{
    kDR_LOG("%@  emptyObjectIndex error", self.class);
    return nil;
}

- (id)arrObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        kDR_LOG("%@  arrObjectIndex error", self.class);
        return nil;
    }
    
    return [self arrObjectIndex:index];
}

- (id)WG_objectAtIndex_NSSingleObjectArrayI:(NSUInteger)index {
    if (index > self.count - 1 || !self.count) {
        kDR_LOG("%@  WG_objectAtIndex_NSSingleObjectArrayI error", self.class);
        return nil;
    } else {
        return [self WG_objectAtIndex_NSSingleObjectArrayI:index];
    }
}

- (id)arrayI_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        kDR_LOG("%@  objectAtIndexedSubscript error", self.class);
        return nil;
    }
    
    return [self arrayI_objectAtIndexedSubscript:index];
}

- (id)arrayM_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        kDR_LOG("%@  objectAtIndexedSubscript error", self.class);
        return nil;
    }
    
    return [self arrayM_objectAtIndexedSubscript:index];
}

- (id)arrayF_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        kDR_LOG("%@  objectAtIndexedSubscript error", self.class);
        return nil;
    }
    
    return [self arrayF_objectAtIndexedSubscript:index];
}

- (id)sw_objectAtIndexedSubscript:(NSInteger)index{
    if (index >= self.count || index < 0) {
        kDR_LOG("%@  objectAtIndexedSubscript error", self.class);
        return nil;
    }
    
    return [self sw_objectAtIndexedSubscript:index];
}

- (id)mutableObjectIndex:(NSInteger)index{
    if (index >= self.count || index < 0) {
        kDR_LOG("%@  mutableObjectIndex error", self.class);
        return nil;
    }
    
    return [self mutableObjectIndex:index];
}

- (void)mutableInsertObject:(id)object atIndex:(NSUInteger)index{
    if (object) {
        [self mutableInsertObject:object atIndex:index];
    }else {
        kDR_LOG("%@  mutableInsertObject error", self.class);
    }
}

- (void)sw_setObject:(id)obj
  atIndexedSubscript:(NSUInteger)index {
    if (index > self.count || index < 0) {
        kDR_LOG("%@  sw_setObject:atIndexedSubscript: error", self.class);
        return;
    }
    
    return [self sw_setObject:obj
           atIndexedSubscript:index];
}

- (id)safeGetObjectWithIndex:(NSInteger)index {
    if (self.count > index) {
        return self[index];
    }
    return nil;
}

@end


@implementation NSMutableArray (DRSafeInsert)

- (void)safeInsertObject:(id)anObject atIndex:(NSUInteger)index{
    if (anObject) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)safeInsertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes{
    if (objects) {
        [self insertObjects:objects atIndexes:indexes];
    }
}

@end
