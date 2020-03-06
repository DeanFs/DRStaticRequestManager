//
//  NSObject+DRExtension.h
//  Records
//
//  Created by admin on 2017/12/7.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (DRExtension)

+ (instancetype)getProperties:(Class)cls;

+(BOOL)compareObjectValue:(NSObject *)object WithObject:(NSObject *)object1;

+ (BOOL)compareSystemEventObjectValue:(NSObject *)object WithObject:(NSObject *)object1;

+ (void)swizzleOriginSelector:(SEL)originSel targetSel:(SEL)targetSel;

+ (void)swizzleClassOriginSelector:(SEL)originalSelector targetSel:(SEL)swizzledSelector;

- (NSString *)className;

@end
