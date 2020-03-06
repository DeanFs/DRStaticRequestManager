//
//  UIScrollView+DRExtension.m
//  AFNetworking
//
//  Created by 冯生伟 on 2019/5/22.
//

#import "UIScrollView+DRExtension.h"

@implementation UIScrollView (DRExtension)

- (void)setInsetTop:(CGFloat)insetTop {
    UIEdgeInsets edge = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(insetTop,
                                         edge.left,
                                         edge.bottom,
                                         edge.right);
}

- (CGFloat)insetTop {
    return self.contentInset.top;
}

- (void)setInsetLeft:(CGFloat)insetLeft {
    UIEdgeInsets edge = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(edge.top,
                                         insetLeft,
                                         edge.bottom,
                                         edge.right);
}

- (CGFloat)insetLeft {
    return self.contentInset.left;
}

- (void)setInsetBottom:(CGFloat)insetBottom {
    UIEdgeInsets edge = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(edge.top,
                                         edge.left,
                                         insetBottom,
                                         edge.right);
}

- (CGFloat)insetBottom {
    return self.contentInset.bottom;
}

- (void)setInsetRight:(CGFloat)insetRight {
    UIEdgeInsets edge = self.contentInset;
    self.contentInset = UIEdgeInsetsMake(edge.top,
                                         edge.left,
                                         edge.bottom,
                                         insetRight);
}

- (CGFloat)insetRight {
    return self.contentInset.right;
}

- (BOOL)isBusy {
    return self.tracking || self.isDragging || self.decelerating;
}

@end
