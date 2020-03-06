//
//  UINavigationBar+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationBar (DRExtension)

+ (CGFloat)navigationBarHeight;
- (CGFloat)navigationBarHeight;
+ (BOOL )isIphoneXSeries;
+ (CGFloat)navigationBarTopHeight;

@end

NS_ASSUME_NONNULL_END
