//
//  NSNumber+DRExtension.h
//  Records
//
//  Created by 冯生伟 on 2018/8/15.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (DRExtension)

- (NSString *)roundDownFormat2Digit; // 强制保留2位小数，添加千分位符

- (NSDecimalNumber *)decimalNumberWithMax2Digit; // 保留最多2位小数
- (NSString *)stringValueWithMax2Digit; // 保留最多2位小数
- (NSString *)stringValueWithForce2Digit; // 强制保留两位小数

- (NSDecimalNumber *)decimalNumberWithMax4Digit; // 保留最多4位小数
- (NSString *)stringValueWithMax4Digit; // 保留最多4位小数位


/**
 获取指定位数小数位数值字符串

 @param digit 指定小数位数
 @param isForce 是否固定小数位数，不足将会补0
 @param block 可对NumberFormatter添加额外设置
 @return 返回格式化数值字符串
 */
- (NSString *)stringValueWithDigit:(int)digit isForce:(BOOL)isForce block:(void(^)(NSNumberFormatter *formt))block;

@end
