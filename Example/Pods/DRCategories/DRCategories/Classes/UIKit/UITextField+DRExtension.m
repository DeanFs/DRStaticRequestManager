//
//  UITextField+DRExtension.m
//  Records
//
//  Created by 冯生伟 on 2018/10/31.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UITextField+DRExtension.h"
#import "DRInputLimitManager.h"

@implementation UITextField (DRExtension)

// 设置占位字符颜色，字号
- (void)setPlaceholder:(NSString *)placeholder
                 color:(UIColor *)color
                  font:(UIFont *)font {
    NSDictionary *attrs = @{
                            NSFontAttributeName: font,
                            NSForegroundColorAttributeName: color
                            };
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:placeholder attributes:attrs];
    self.attributedPlaceholder = attStr;
}

// 正在输入拼音
- (BOOL)isInputingPinyin {
    UITextRange *selectedRange = [self markedTextRange];
    UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
    if (position) {
        return YES;
    }
    return NO;
}

// 设置字数限制，字母，汉字，表情符号均算一个字
- (void)setTextLengthLimit:(NSInteger)limit {
    [DRInputLimitManager addTextLimitForbidStartWithSpaceCharForInputView:self
                                                      textDidChangeNotice:UITextFieldTextDidChangeNotification
                                                                    limit:limit
                                                         beyondLimitBlock:nil
                                                           checkDoneBlock:nil];
}

@end
