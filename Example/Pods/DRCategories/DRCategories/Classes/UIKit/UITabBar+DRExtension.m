//
//  UITabBar+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import "UITabBar+DRExtension.h"
#import "UINavigationBar+DRExtension.h"

@implementation UITabBar (DRExtension)

+ (CGFloat)tabBarHeight {
    if ([UINavigationBar isIphoneXSeries]) {
        return 49.0 + [self iPhoneXTabarSafeHeight];
    }
    return 49.0;
}

+ (CGFloat)safeHeight {
    if ([UINavigationBar isIphoneXSeries]) {
        return 34.0;
    }
    return 0.0;
}

+ (CGFloat)iPhoneXTabarSafeHeight {
    return 34;
}

- (CGFloat)tabBarHeight {
    return [UITabBar tabBarHeight];
}


@end
