//
//  NSAttributedString+DRExtension.h
//  Records
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (DRExtension)
/**
 添加一个富文本Placeholder

 @param image 前置图片
 @param title title description
 @param font 字体
 @param color 字体颜色
 @return 富文本
 */
+ (NSAttributedString *)attributedPlaceholderWithImage:(UIImage *)image
                                                title:(NSString *)title
                                                font:(UIFont *)font
                                                color:(UIColor *)color;


/**
 初始化安全富文本，对字符串空判断

 @param str 字符串
 @return 富文本
 */
- (instancetype)initWithSafeString:(NSString *)str;

@end
