//
//  UITextField+DRExtension.h
//  Records
//
//  Created by 冯生伟 on 2018/10/31.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (DRExtension)

// 设置占位字符颜色，字号
- (void)setPlaceholder:(NSString *)placeholder
                 color:(UIColor *)color
                  font:(UIFont *)font;

// 正在输入拼音
- (BOOL)isInputingPinyin;

// 设置字数限制，字母，汉字，表情符号均算一个字
// 禁止在开始位置输入空格
- (void)setTextLengthLimit:(NSInteger)limit;

@end

NS_ASSUME_NONNULL_END
