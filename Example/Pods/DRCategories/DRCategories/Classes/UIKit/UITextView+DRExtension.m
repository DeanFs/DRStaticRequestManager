//
//  UITextView+DRExtension.m
//  Records
//
//  Created by 冯生伟 on 2018/10/25.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UITextView+DRExtension.h"
#import "DRInputLimitManager.h"

@implementation UITextView (DRExtension)

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
                                                      textDidChangeNotice:UITextViewTextDidChangeNotification
                                                                    limit:limit
                                                         beyondLimitBlock:nil
                                                           checkDoneBlock:nil];
}

@end
