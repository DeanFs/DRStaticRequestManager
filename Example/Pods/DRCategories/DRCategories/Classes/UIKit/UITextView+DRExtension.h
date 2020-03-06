//
//  UITextView+DRExtension.h
//  Records
//
//  Created by 冯生伟 on 2018/10/25.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (DRExtension)

// 正在输入拼音
- (BOOL)isInputingPinyin;

// 设置字数限制，字母，汉字，表情符号均算一个字
// 禁止在开始位置输入空格、换行
- (void)setTextLengthLimit:(NSInteger)limit;

@end
