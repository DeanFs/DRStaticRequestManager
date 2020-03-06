//
//  NSMutableSet+DRExtension.m
//  Records
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "NSMutableSet+DRExtension.h"

@implementation NSMutableSet (DRExtension)

- (void)safeAddObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

@end
