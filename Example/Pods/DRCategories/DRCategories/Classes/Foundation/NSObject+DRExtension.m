//
//  NSObject+DRExtension.m
//  Records
//
//  Created by admin on 2017/12/7.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "NSObject+DRExtension.h"

@implementation NSObject (DRExtension)
//返回当前类的所有属性
+ (instancetype)getProperties:(Class)cls {    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
}

+ (BOOL)compareObjectValue:(NSObject *)object WithObject:(NSObject *)object1 {
    if (![NSStringFromClass([object class])isEqualToString:NSStringFromClass([object1 class])]) {
        return NO;
    }
    NSArray *properties=(NSArray *)[NSObject getProperties:object_getClass(object)];
    for (NSString *key in properties) {
        NSString *firstString= [NSString stringWithFormat:@"%@",[object valueForKeyPath:key]];
        NSString *lastSting= [NSString stringWithFormat:@"%@",[object1 valueForKeyPath:key]];
        if(![firstString isEqualToString:lastSting]){
            return NO;
        }
    }
    return YES;
}

+ (BOOL)compareSystemEventObjectValue:(NSObject *)object WithObject:(NSObject *)object1 {
    if (![[object class] isSubclassOfClass:[object1 class]]) {
        return NO;
    }
    NSArray *properties=(NSArray *)[NSObject getProperties:object_getClass(object)];
    for (NSString *key in properties) {
        if ([key isEqualToString:@"isimportant"] || [key isEqualToString:@"colorid"]) {
            continue;
        }
        if ([object valueForKeyPath:key]||[object1 valueForKeyPath:key]) {
            if ([[[object valueForKeyPath:key] className] isEqualToString:@"__NSCFString"]&&[[[object1 valueForKeyPath:key] className] isEqualToString:@"__NSCFString"]) {//字符串判断
                if (![[object valueForKeyPath:key]isEqualToString:[object1 valueForKeyPath:key]]) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

+ (void)swizzleOriginSelector:(SEL)originalSelector targetSel:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleClassOriginSelector:(SEL)originalSelector targetSel:(SEL)swizzledSelector {
    Class class = [self class];
    
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
