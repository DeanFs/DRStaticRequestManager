//
//  NSNumber+DRExtension.m
//  Records
//
//  Created by 冯生伟 on 2018/8/15.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "NSNumber+DRExtension.h"

@implementation NSNumber (DRExtension)

- (NSString *)roundDownFormat2Digit {
    return [self stringValueWithDigit:2 isForce:YES block:^(NSNumberFormatter *formt) {
        [formt setUsesGroupingSeparator:YES];
    }];
}

- (NSDecimalNumber *)decimalNumberWithMax2Digit {
    return [NSDecimalNumber decimalNumberWithString:[self stringValueWithMax2Digit]];
}

- (NSString *)stringValueWithMax2Digit {
    return [self stringValueWithDigit:2 isForce:NO block:nil];
}

- (NSString *)stringValueWithForce2Digit {
    return [self stringValueWithDigit:2 isForce:YES block:nil];
}

- (NSDecimalNumber *)decimalNumberWithMax4Digit {
    return [NSDecimalNumber decimalNumberWithString:[self stringValueWithMax4Digit]];
}


- (NSString *)stringValueWithMax4Digit {
    return [self stringValueWithDigit:4 isForce:NO block:nil];
}

- (NSString *)stringValueWithDigit:(int)digit isForce:(BOOL)isForce block:(void(^)(NSNumberFormatter *formt))block {
    NSNumberFormatter *formt = [[NSNumberFormatter alloc] init];
    [formt setMaximumFractionDigits:digit];
    if (isForce) {
        [formt setMinimumFractionDigits:digit];
    }
    [formt setUsesGroupingSeparator:NO]; // 不显示千分位符
    [formt setNumberStyle:NSNumberFormatterDecimalStyle];
    [formt setRoundingMode:NSNumberFormatterRoundFloor];
    
    if (block) {
        block(formt);
    }
    
    return [formt stringFromNumber:self];
}

@end
