//
//  UINavigationBar+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import "UINavigationBar+DRExtension.h"
#import "UIView+DRExtension.h"

@implementation UINavigationBar (DRExtension)

+ (CGFloat)navigationBarHeight {
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    return statusBarHeight + 44.0;
}

+ (CGFloat)navigationBarTopHeight {
    if ([self isIphoneXSeries]) {
        return 22.0;
    }
    return 0.0;
}

- (CGFloat)navigationBarHeight {
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    return statusBarHeight + self.height;
}

+ (BOOL )isIphoneXSeries {
    if (@available(iOS 11.0, *)) {
        return  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }else{
        return NO;
    }
}

@end
