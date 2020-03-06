//
//  UIScrollView+DRExtension.h
//  AFNetworking
//
//  Created by 冯生伟 on 2019/5/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (DRExtension)

@property (nonatomic, assign) CGFloat insetTop;
@property (nonatomic, assign) CGFloat insetLeft;
@property (nonatomic, assign) CGFloat insetBottom;
@property (nonatomic, assign) CGFloat insetRight;
@property (nonatomic, assign, readonly) BOOL isBusy;

@end

NS_ASSUME_NONNULL_END
