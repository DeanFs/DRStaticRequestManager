//
//  UIView+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/6.
//

#import "UIView+DRExtension.h"
#import <pop/POPSpringAnimation.h>
#import <pop/POPBasicAnimation.h>
#import <objc/runtime.h>
#import <DRMacroDefines/DRMacroDefines.h>

#pragma mark - 快速获取和设置Frame信息
@implementation UIView (DRExtension)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setTop:(CGFloat)t {
    self.frame = CGRectMake(self.left, t, self.width, self.height);
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setBottom:(CGFloat)b {
    self.frame = CGRectMake(self.left, b - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setLeft:(CGFloat)l {
    self.frame = CGRectMake(l, self.top, self.width, self.height);
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setRight:(CGFloat)r {
    self.frame = CGRectMake(r - self.width, self.top, self.width, self.height);
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

/**
 指定边角设置圆角，需要在视图加载完成后调用
 
 @param corners 指定边角
 @param cornerRadius 圆角半径
 */
- (void)addRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        self.layer.mask = shape;
        self.layer.masksToBounds = YES;
    });
}

/**
 检测视图内是否有正在滚动的视图
 
 @param view 待检测视图
 @return YES：有正在滚动的视图，NO：没有
 */
- (BOOL)anySubViewScrolling:(UIView *)view {
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

@end


#pragma mark - 动画
@implementation UIView (DRAnimation)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)animationCurve {
    switch (animationCurve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    return kNilOptions;
}

- (void)springScaleAnimateShow {
    [self.layer pop_removeAnimationForKey:@"SpringShowAnimation"];
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSubscaleXY];
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.5, 0.5)];
    springAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    springAnimation.springBounciness = 20;
    springAnimation.beginTime = 0.3;
    springAnimation.removedOnCompletion = true;
    [self.layer pop_addAnimation:springAnimation forKey:@"SpringShowAnimation"];
}

- (void)dismissView {
    [self.layer pop_removeAnimationForKey:@"SubscaleXY"];
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSubscaleXY];
    springAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    springAnimation.toValue =[NSValue valueWithCGPoint:CGPointMake(0.01, 0.01)];
    springAnimation.springBounciness = 15;
    springAnimation.removedOnCompletion = true;
    [self.layer pop_addAnimation:springAnimation forKey:@"SubscaleXY"];
    
    [self.layer pop_removeAnimationForKey:@"opacity"];
    POPSpringAnimation* opacity = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacity.fromValue = @(1);
    opacity.toValue = @(0);
    opacity.springBounciness = 15;
    opacity.removedOnCompletion = true;
    [self.layer pop_addAnimation:opacity forKey:@"opacity"];
    
    opacity.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    };
}

/*
 透明动画
 */
- (void)animateWithAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:kDRAnimationDuration
                     animations:^{
                         self.alpha = alpha;
                     }];
}


/*
 平移动画参数
 */
- (void)translateAnimateFromPoint:(CGPoint)fromPt {
    [self translateAnimateFromPoint:fromPt
                           complete:nil];
}

/*
 平移动画参数
 */
- (void)translateAnimateFromPoint:(CGPoint)fromPt
                         complete:(void (^)(BOOL finish))complete {
    [self.layer pop_removeAnimationForKey:@"DirectionAnimation"];
    [self pop_removeAnimationForKey:@"alphaChange"];
    POPSpringAnimation* springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerTranslationXY];
    springAnimation.fromValue = [NSValue valueWithCGPoint:fromPt];
    springAnimation.toValue = [NSValue valueWithCGPoint:CGPointZero];
    springAnimation.springBounciness = 10;
    springAnimation.removedOnCompletion = true;
    
    springAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        kDR_SAFE_BLOCK(complete, finished);
    };
    
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basicAnimation.fromValue = @0;
    basicAnimation.toValue = @1;
    basicAnimation.duration = 0.8;
    
    [self pop_addAnimation:basicAnimation forKey:@"alphaChange"];
    [self.layer pop_addAnimation:springAnimation forKey:@"DirectionAnimation"];
}

/**
 中心发散波纹动画
 
 @param radarColor 扩散颜色
 @param radarBorderColor 扩散边界颜色
 @param toValue 扩散半径倍率
 @return 返回动画图层
 */
- (CALayer *)addHighlightAnimationWithRadarColor:(UIColor *)radarColor
                                radarBorderColor:(UIColor *)radarBorderColor
                                         toValue:(CGFloat)toValue  {
    return [self addHighlightAnimationWithRadarColor:radarColor
                                    radarBorderColor:radarBorderColor
                                             toValue:toValue
                                            duration:2
                                        pulsingCount:3];
}

/**
 中心发散波纹动画
 
 @param radarColor 扩散颜色
 @param radarBorderColor 扩散边界颜色
 @param toValue 扩散半径倍率
 @param duration 单个动画(一条波纹动画)时长
 @param pulsingCount 波纹线条数
 @return 返回动画图层
 */
- (CALayer *)addHighlightAnimationWithRadarColor:(UIColor *)radarColor
                                radarBorderColor:(UIColor *)radarBorderColor
                                         toValue:(CGFloat)toValue
                                        duration:(CGFloat)duration
                                    pulsingCount:(NSInteger)pulsingCount {
    CALayer * animationLayer = [[CALayer alloc]init];
    
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [[CALayer alloc] init];
        pulsingLayer.frame = self.frame;
        pulsingLayer.backgroundColor = radarColor.CGColor;
        pulsingLayer.borderColor = radarBorderColor.CGColor;
        
        pulsingLayer.borderWidth = 1.0;
        pulsingLayer.cornerRadius = CGRectGetHeight(pulsingLayer.frame)/2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
        animationGroup.fillMode = kCAFillModeBoth;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * duration/(double)pulsingCount;
        animationGroup.duration = duration;
        animationGroup.repeatCount = HUGE_VAL;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithDouble:1];
        scaleAnimation.toValue = [NSNumber numberWithDouble:toValue];
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[[NSNumber numberWithDouble:1.0],[NSNumber numberWithDouble:0.6],[NSNumber numberWithDouble:0.3],[NSNumber numberWithDouble:0.1],[NSNumber numberWithDouble:0.0]];
        opacityAnimation.keyTimes = @[[NSNumber numberWithDouble:0.0],[NSNumber numberWithDouble:0.25],[NSNumber numberWithDouble:0.5],[NSNumber numberWithDouble:0.75],[NSNumber numberWithDouble:1.0]];
        animationGroup.animations = @[scaleAnimation,opacityAnimation];
        
        [pulsingLayer addAnimation:animationGroup forKey:@"pulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.superview.layer insertSublayer:animationLayer below:self.layer];
    return animationLayer;
}

/**
 添加无背景纯打勾动画
 
 @param rect 打勾位置
 @param checkColor 勾颜色
 @param checkWidth 勾线条宽度
 @param completeBlock 动画完成回调
 */
- (void)addCheckAnimationWightRect:(CGRect)rect
                        checkColor:(UIColor *)checkColor
                        checkWidth:(CGFloat)checkWidth
                     completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    CAShapeLayer *checkLayer = [CAShapeLayer checkAnimationLayerWithRect:rect
                                                              checkColor:checkColor
                                                              checkWidth:checkWidth
                                                           completeBlock:completeBlock];
    [self.layer addSublayer:checkLayer];
}

/**
 在圈圈中的打勾动画
 
 @param rect 圈圈大小
 @param checkColor 勾颜色
 @param checkWidth 勾线宽
 @param borderColor 圆圈线圈颜色
 @param borderWidth 圆圈线宽
 @param completeBlock 动画完成回调
 */
- (void)addCheckAnimationInCircleBorderLayerWithRect:(CGRect)rect
                                          checkColor:(UIColor *)checkColor
                                          checkWidth:(CGFloat)checkWidth
                                         borderColor:(UIColor *)borderColor
                                         borderWidth:(CGFloat)borderWidth
                                       completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *checkLayer = [CALayer checkInCircleBorderAnimationLayerWithRect:rect
                                                             checkColor:checkColor
                                                             checkWidth:checkWidth
                                                            borderColor:borderColor
                                                            borderWidth:borderWidth
                                                          completeBlock:completeBlock];
    [self.layer addSublayer:checkLayer];
}

/**
 在圆圈纯色背景中添加打勾动画
 
 @param rect 纯色背景大小
 @param backgroundColor 纯色背景颜色
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param completeBlock 动画完成回调
 */
- (void)addCheckAnimationInCirclePureColorLayerWithRect:(CGRect)rect
                                        backgroundColor:(UIColor *)backgroundColor
                                             checkColor:(UIColor *)checkColor
                                             checkWidth:(CGFloat)checkWidth
                                         completeBolock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *checkLayer = [CALayer checkInCirclePureColorAnimationLayerWithRect:rect
                                                                backgroundColor:backgroundColor
                                                                     checkColor:checkColor
                                                                     checkWidth:checkWidth
                                                                 completeBolock:completeBlock];
    [self.layer addSublayer:checkLayer];
}

/**
 圆圈进度动画，当进度为1时在中心执行打勾动画
 
 @param rect 圆圈大小位置
 @param progressColor 进度条颜色
 @param trackColor 圆圈背景色
 @param strokeWidth 圆圈宽度
 @param currentProgress 当前进度
 @param toProgress 本次完成后进度
 @param completeBlock 动画完成回调
 */
- (void)addCircleProgressAnimationLayerWithRect:(CGRect)rect
                                  progressColor:(UIColor *)progressColor
                                     trackColor:(UIColor *)trackColor
                                    strokeWidth:(CGFloat)strokeWidth
                                currentProgress:(CGFloat)currentProgress
                                     toProgress:(CGFloat)toProgress
                                  completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *progressLayer = [CALayer circleProgressAnimationLayerWithRect:rect
                                                             progressColor:progressColor
                                                                trackColor:trackColor
                                                               strokeWidth:strokeWidth
                                                           currentProgress:currentProgress
                                                                toProgress:toProgress
                                                             completeBlock:completeBlock];
    [self.layer addSublayer:progressLayer];
}

@end


@implementation UIView (DRLayerGradient)

// 从上到下
- (CAGradientLayer *)setGradientFromTopColor:(UIColor *)fromColor
                  toBottomColor:(UIColor *)toColor {
    return [self setGradientFromTopColor:fromColor
                           toBottomColor:toColor
                            cornerRadius:0];
}

- (CAGradientLayer *)setGradientFromTopColor:(UIColor *)fromColor
                  toBottomColor:(UIColor *)toColor
                   cornerRadius:(CGFloat)cornerRadius {
    CAGradientLayer *layer = [CAGradientLayer gradientLayerWithFrame:self.bounds
                                                            topColor:fromColor
                                                         bottomColor:toColor
                                                        cornerRadius:cornerRadius];
    [self.layer insertSublayer:layer atIndex:0];
    return layer;
}

- (CAGradientLayer *)setGradientFromLeftColor:(UIColor *)fromColor
                    toRightColor:(UIColor *)toColor {
    return [self setGradientFromLeftColor:fromColor
                             toRightColor:toColor
                             cornerRadius:0];
}


- (CAGradientLayer *)setGradientFromLeftColor:(UIColor *)fromColor
                    toRightColor:(UIColor *)toColor
                    cornerRadius:(CGFloat)cornerRadius {
    CAGradientLayer *layer = [CAGradientLayer gradientLayerWithFrame:self.bounds
                                                           leftColor:fromColor
                                                          rightColor:toColor
                                                        cornerRadius:cornerRadius];
    [self.layer insertSublayer:layer atIndex:0];
    return layer;
}

@end

