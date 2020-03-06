//
//  NSAttributedString+DRExtension.m
//  Records
//
//  Created by admin on 2018/1/4.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "NSAttributedString+DRExtension.h"

@implementation NSAttributedString (DRExtension)

+ (NSAttributedString *)attributedPlaceholderWithImage:(UIImage *)image title:(NSString *)title font:(UIFont *)font color:(UIColor *)color{
    // 创建一个富文本
    NSMutableAttributedString * attriStr = [[NSMutableAttributedString alloc] initWithSafeString:title];
    // 修改富文本中的不同文字的样式
    [attriStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, title.length)];
    [attriStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, title.length)];
    
    /**
     添加图片到指定的位置
     */
    if (image) {
        NSTextAttachment *attachImage = [[NSTextAttachment alloc] init];
        // 表情图片
        attachImage.image = image;
        // 设置图片大小
        attachImage.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
        NSAttributedString *attachImageView = [NSAttributedString attributedStringWithAttachment:attachImage];
        [attriStr insertAttributedString:attachImageView atIndex:0];
    }
    return attriStr;
}

#pragma mark - 字符串检测
- (instancetype)initWithSafeString:(NSString *)str{
    if (str) {
        return [self initWithString:str];
    } else {
        return [self initWithString:@" "];
    }
}

@end
