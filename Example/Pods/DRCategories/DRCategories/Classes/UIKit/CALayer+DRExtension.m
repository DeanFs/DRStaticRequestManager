//
//  CALayer+DRExtension.m
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/6.
//

#import "CALayer+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <pop/POPBasicAnimation.h>
#import "CAAnimation+DRExtension.h"

@implementation CALayer (DRExtension)

- (void)setBorderUIColor:(UIColor*)color {
    self.borderColor = color.CGColor;
}

- (UIColor*)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

/**
 构建圆圈layer
 
 @param rect 大小及位置
 @param color 圆圈颜色
 @param borderWidth 圆圈线宽
 @return 返回圆圈layer
 */
+ (instancetype)circleBorderLayerWithRect:(CGRect)rect
                                    color:(UIColor *)color
                              borderWidth:(CGFloat)borderWidth {
    return [self borderLayerWithRect:rect
                               color:color
                         borderWidth:borderWidth
                        cornerRadius:rect.size.width/2];
}

/**
 构建封闭矩形、圆角layer
 
 @param rect 大小及位置
 @param color 圆圈颜色
 @param borderWidth 圆圈线宽
 @param cornerRadius 圆角半径
 @return layer
 */
+ (instancetype)borderLayerWithRect:(CGRect)rect
                              color:(UIColor *)color
                        borderWidth:(CGFloat)borderWidth
                       cornerRadius:(CGFloat)cornerRadius {
    CALayer *layer = [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.borderColor = color.CGColor;
    layer.borderWidth = borderWidth;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
    return layer;
}

/**
 构建圆形纯色layer
 
 @param rect 大小及位置
 @param color 背景颜色
 @return layer
 */
+ (instancetype)circlePureColorLayerWithRect:(CGRect)rect
                                       color:(UIColor *)color {
    return [self pureColorLayerWithRect:rect
                                  color:color
                           cornerRadius:rect.size.width/2];
}

/**
 构建矩形、圆角纯色layer
 
 @param rect 大小及位置
 @param color 背景颜色
 @param cornerRadius 圆角半径
 @return layer
 */
+ (instancetype)pureColorLayerWithRect:(CGRect)rect
                                 color:(UIColor *)color
                          cornerRadius:(CGFloat)cornerRadius {
    CALayer *layer = [CALayer layer];
    layer.frame = rect;
    layer.backgroundColor = color.CGColor;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
    return layer;
}

#pragma mark - 组合图层，用于构建图片
/**
 圆圈中叠加勾组合图层
 
 @param rect 圆圈大小及位置
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param borderColor 圆线圈颜色
 @param borderWidth 圆线圈宽度
 @return 返回组合图层
 */
+ (instancetype)checkInCircleBorderLayerWithRect:(CGRect)rect
                                      checkColor:(UIColor *)checkColor
                                      checkWidth:(CGFloat)checkWidth
                                     borderColor:(UIColor *)borderColor
                                     borderWidth:(CGFloat)borderWidth {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = rect;
    
    CALayer *circleLayer = [CALayer circleBorderLayerWithRect:containerLayer.bounds
                                                        color:borderColor
                                                  borderWidth:borderWidth];
    [containerLayer addSublayer:circleLayer];
    
    CAShapeLayer *checkLayer = [CAShapeLayer checkLayerWithRect:containerLayer.bounds
                                                     checkColor:checkColor
                                                     checkWidth:checkWidth];
    [containerLayer addSublayer:checkLayer];
    return containerLayer;
}

/**
 圆圈纯色背景中叠加勾图层

 @param rect 圆圈纯色背景大小
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param backgroundColor 圆圈背景色
 @return 返回组合图层
 */
+ (instancetype)checkInCirclePureColorLayerWithRect:(CGRect)rect
                                         checkColor:(UIColor *)checkColor
                                         checkWidth:(CGFloat)checkWidth
                                    backgroundColor:(UIColor *)backgroundColor {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = rect;
    
    CALayer *circleLayer = [CALayer circlePureColorLayerWithRect:containerLayer.bounds
                                                     color:backgroundColor];
    [containerLayer addSublayer:circleLayer];
    
    CAShapeLayer *checkLayer = [CAShapeLayer checkLayerWithRect:containerLayer.bounds
                                                     checkColor:checkColor
                                                     checkWidth:checkWidth];
    [containerLayer addSublayer:checkLayer];
    return containerLayer;
}

/**
 构建圆圈进度layer
 
 @param rect 大小及位置
 @param progressColor 进度颜色
 @param trackColor 圆圈底色
 @param strokeWidth 圆圈线宽
 @param progress 进度值
 @return layer
 */
+ (instancetype)circleProgressLayerWithRect:(CGRect)rect
                              progressColor:(UIColor *)progressColor
                                 trackColor:(UIColor *)trackColor
                                strokeWidth:(CGFloat)strokeWidth
                                   progress:(CGFloat)progress {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = rect;
    
    CALayer *circleLayer = [CALayer circleBorderLayerWithRect:containerLayer.bounds
                                                        color:trackColor
                                                  borderWidth:strokeWidth];
    [containerLayer addSublayer:circleLayer];
    
    if (progress > 0) {
        CAShapeLayer *progressLayer = [CAShapeLayer circelProgressLayerWithRect:containerLayer.bounds
                                                                  progressColor:progressColor
                                                                    strokeWidth:strokeWidth
                                                                currentProgress:0
                                                                     toProgress:progress];
        [containerLayer addSublayer:progressLayer];
    }
    return containerLayer;
}

#pragma mark - 渐变图层
/// 从上到下渐变图层
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                              topColor:(UIColor *)topColor
                           bottomColor:(UIColor *)bottomColor
                          cornerRadius:(CGFloat)cornerRadius {
    return [CAGradientLayer gradientLayerWithFrame:frame
                                          topColor:topColor
                                       bottomColor:bottomColor
                                      cornerRadius:cornerRadius];
}
/// 从右到左渐变
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                             leftColor:(UIColor *)leftColor
                            rightColor:(UIColor *)rightColor
                          cornerRadius:(CGFloat)cornerRadius {
    return [CAGradientLayer gradientLayerWithFrame:frame
                                         leftColor:leftColor
                                        rightColor:rightColor
                                      cornerRadius:cornerRadius];
}

@end


@implementation CALayer (DRAnimation)
/**
 线圈中执行打勾动画

 @param rect 线圈大小
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param borderColor 圈线条颜色
 @param borderWidth 圈线条宽度
 @param completeBlock 动画完成回调
 @return 返回承载两种动画的图层
 */
+ (instancetype)checkInCircleBorderAnimationLayerWithRect:(CGRect)rect
                                               checkColor:(UIColor *)checkColor
                                               checkWidth:(CGFloat)checkWidth
                                              borderColor:(UIColor *)borderColor
                                              borderWidth:(CGFloat)borderWidth
                                            completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = rect;
    
    __block BOOL scaleDone, checkDone;
    CALayer *circleLayer = [CALayer circleBorderLayerWithRect:containerLayer.bounds
                                                        color:borderColor
                                                  borderWidth:borderWidth];
    [circleLayer addScaleAnimationWithCompleteBlock:^(CALayer *layer){
        scaleDone = YES;
        if (scaleDone && checkDone) {
            kDR_SAFE_BLOCK(completeBlock, containerLayer);
        }
    }];
    [containerLayer addSublayer:circleLayer];
    
    CAShapeLayer *checkLayer = [CAShapeLayer checkAnimationLayerWithRect:containerLayer.bounds checkColor:checkColor checkWidth:checkWidth completeBlock:^(CALayer *layer){
        checkDone = YES;
        if (scaleDone && checkDone) {
            kDR_SAFE_BLOCK(completeBlock, containerLayer);
        }
    }];
    [containerLayer addSublayer:checkLayer];
    
    return containerLayer;
}

/**
 在圆圈纯色背景中添加打勾动画
 
 @param rect 纯色背景大小
 @param backgroundColor 纯色背景颜色
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param completeBlock 动画完成回调
 @return 返回承载两种动画的图层
 */
+ (instancetype)checkInCirclePureColorAnimationLayerWithRect:(CGRect)rect
                                             backgroundColor:(UIColor *)backgroundColor
                                                  checkColor:(UIColor *)checkColor
                                                  checkWidth:(CGFloat)checkWidth
                                              completeBolock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = rect;
    
    __block BOOL scaleDone, checkDone;
    CALayer *circleLayer = [CALayer circlePureColorLayerWithRect:containerLayer.bounds
                                                           color:backgroundColor];
    [circleLayer addScaleAnimationWithCompleteBlock:^(CALayer *layer){
        scaleDone = YES;
        if (scaleDone && checkDone) {
            kDR_SAFE_BLOCK(completeBlock, containerLayer);
        }
    }];
    [containerLayer addSublayer:circleLayer];
    
    CAShapeLayer *checkLayer = [CAShapeLayer checkAnimationLayerWithRect:containerLayer.bounds checkColor:checkColor checkWidth:checkWidth completeBlock:^(CALayer *layer){
        checkDone = YES;
        if (scaleDone && checkDone) {
            kDR_SAFE_BLOCK(completeBlock, containerLayer);
        }
    }];
    [containerLayer addSublayer:checkLayer];
    
    return containerLayer;
}

/**
 圆圈进度动画
 
 @param rect 圆圈大小位置
 @param progressColor 进度条颜色
 @param trackColor 圆圈背景色
 @param strokeWidth 圆圈宽度
 @param currentProgress 当前进度
 @param toProgress 本次完成后进度
 @param completeBlock 动画完成回调
 @return 返回组合图层
 */
+ (instancetype)circleProgressAnimationLayerWithRect:(CGRect)rect
                                       progressColor:(UIColor *)progressColor
                                          trackColor:(UIColor *)trackColor
                                         strokeWidth:(CGFloat)strokeWidth
                                     currentProgress:(CGFloat)currentProgress
                                          toProgress:(CGFloat)toProgress
                                       completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = rect;
    
    CALayer *circleLayer = [CALayer circleProgressLayerWithRect:containerLayer.bounds
                                                  progressColor:progressColor
                                                     trackColor:trackColor
                                                    strokeWidth:strokeWidth
                                                       progress:currentProgress];
    [containerLayer addSublayer:circleLayer];
    
    CAShapeLayer *progressLayer = [CAShapeLayer circelProgressLayerWithRect:circleLayer.bounds
                                                              progressColor:progressColor
                                                                strokeWidth:strokeWidth
                                                            currentProgress:currentProgress
                                                                 toProgress:toProgress];
    [containerLayer addSublayer:progressLayer];
    
    __block BOOL scaleDone, progressDone;
    [containerLayer addScaleAnimationWithCompleteBlock:^(CALayer *layer){
        scaleDone = YES;
        if (scaleDone && progressDone) {
            kDR_SAFE_BLOCK(completeBlock, layer);
        }
    }];
    [progressLayer addStrokeAnimationWithCompleteBlock:^(CALayer *layer){
        progressDone = YES;
        if (scaleDone && progressDone) {
            kDR_SAFE_BLOCK(completeBlock, containerLayer);
        }
    }];
    
    return containerLayer;
}

#pragma mark - 缩放动画
- (void)addScaleAnimationWithCompleteBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    [self addScaleAnimationWithDuration:kDRAnimationDuration completeBlock:completeBlock];
}

- (void)addScaleAnimationWithDuration:(CGFloat)duration completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    kDRWeakSelf
    CAKeyframeAnimation *animation = [CAAnimation keyframeAnimationWithKeyPath:@"transform.scale"
                                                                        values:@[@1.2,@0.8,@1.1,@0.9,@1]
                                                                      duration:duration
                                                                   repeatCount:0
                                                           removedOnCompletion:YES
                                                                 completeBlock:^(CAAnimation * _Nonnull animation, BOOL finished) {
                                                                     if (finished) {
                                                                         kDR_SAFE_BLOCK(completeBlock, weakSelf);
                                                                     }
                                                                 }];
    [self addAnimation:animation forKey:@"scaleAnimation"];
}

/**
 创建添加了打勾动画的layer
 
 @param rect 打勾位置及大小，内部有一定缩小
 @param checkColor 勾颜色
 @param checkWidth 勾线条宽度
 @param duration 动画时长
 @param completeBlock 动画完成回调
 @return 动画layer
 */
+ (instancetype)checkAnimationLayerWithRect:(CGRect)rect
                                 checkColor:(UIColor *)checkColor
                                 checkWidth:(CGFloat)checkWidth
                                   duration:(CGFloat)duration
                              completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    CALayer *container = [CALayer layer];
    container.frame = rect;
    
    CAShapeLayer *checkLayer = [CAShapeLayer checkLayerWithRect:container.bounds
                                                     checkColor:checkColor
                                                     checkWidth:checkWidth];
    [container addSublayer:checkLayer];
    [checkLayer addStrokeAnimationWithDuration:duration completeBlock:completeBlock];
    
    return container;
}

@end


@implementation CAShapeLayer (DRExtension)

/**
 构建指定路径的线条layer

 @param rect 展示位置和大小
 @param strokeColor 线条颜色
 @param strokeWidth 线条宽度
 @param path 线条路径
 @return shapeLayer
 */
+ (instancetype)strokeLineLayerWithRect:(CGRect)rect
                                  color:(UIColor *)strokeColor
                            strokeWidth:(CGFloat)strokeWidth
                             bezierPath:(UIBezierPath *)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = rect;
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = strokeWidth;
    shapeLayer.lineCap = kCALineCapRound; //线条拐角
    return shapeLayer;
}

/**
 构建打勾图层

 @param rect 勾显示大小，有固定比例内边距，不会撑满size
 @param checkColor 勾显示颜色
 @param checkWidth 勾宽度
 @return 打勾图层layer
 */
+ (instancetype)checkLayerWithRect:(CGRect)rect
                        checkColor:(UIColor *)checkColor
                        checkWidth:(CGFloat)checkWidth {
    // 打勾路劲
    CGFloat reduceScale = 0.25;
    CGRect checkRect = CGRectInset(rect, rect.size.width*reduceScale/2, rect.size.height*reduceScale/2);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(checkRect.origin.x + checkRect.size.width*3/18, checkRect.origin.y + checkRect.size.height/2)];
    [path addLineToPoint:CGPointMake(checkRect.origin.x + checkRect.size.width*8/21, checkRect.origin.y + checkRect.size.height*17/24)];
    [path addLineToPoint:CGPointMake(checkRect.origin.x + checkRect.size.width*4/5, checkRect.origin.y + checkRect.size.height*3/10)];
    
    // 打勾动画执行的layer
    CAShapeLayer *checkLayer = [CAShapeLayer strokeLineLayerWithRect:rect color:checkColor strokeWidth:checkWidth bezierPath:path];
    checkLayer.frame = rect;
    return checkLayer;
}

/**
 构建圆圈进度layer，仅绘制指定进度的圆弧
 
 @param rect 大小及位置
 @param progressColor 进度颜色
 @param strokeWidth 圆圈线宽
 @param currentProgress 当前进度值
 @param toProgress 目标进度
 @return layer
 */
+ (instancetype)circelProgressLayerWithRect:(CGRect)rect
                              progressColor:(UIColor *)progressColor
                                strokeWidth:(CGFloat)strokeWidth
                            currentProgress:(CGFloat)currentProgress
                                 toProgress:(CGFloat)toProgress {
    CGSize size = rect.size;
    CGPoint center = CGPointMake(size.width/2, size.height/2);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:(size.width-strokeWidth)/2
                                                    startAngle:(1.5+2*currentProgress)*M_PI
                                                      endAngle:(1.5+2*toProgress)*M_PI
                                                     clockwise:YES];
    CAShapeLayer *progressLayer = [CAShapeLayer strokeLineLayerWithRect:rect
                                                                  color:progressColor
                                                            strokeWidth:strokeWidth
                                                             bezierPath:path];
    return progressLayer;
}

@end


@implementation CAShapeLayer (DRAnimation)

/**
 添加路径绘制动画，动画填充指定的path
 
 @param completeBlock 动画完成回调
 */
- (void)addStrokeAnimationWithCompleteBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    [self addStrokeAnimationWithDuration:kDRAnimationDuration completeBlock:completeBlock];
}

/**
 添加路径绘制动画，动画填充指定的path
 
 @param duration 动画时长
 @param completeBlock 动画完成回调
 */
- (void)addStrokeAnimationWithDuration:(CGFloat)duration
                         completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    kDRWeakSelf
    POPBasicAnimation *checkAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    checkAnimation.duration = duration;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.removedOnCompletion = YES;
    checkAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
        if (finished) {
            kDR_SAFE_BLOCK(completeBlock, weakSelf);
        }
    };
    [self pop_addAnimation:checkAnimation forKey:@"strokeAnimation"];
}

#pragma mark - 创建打勾动画图层
/**
 创建添加了打勾动画的layer
 
 @param rect 打勾位置及大小，内部有一定缩小
 @param checkColor 勾颜色
 @param checkWidth 勾线条宽度
 @param completeBlock 动画完成回调
 @return 动画layer
 */
+ (instancetype)checkAnimationLayerWithRect:(CGRect)rect
                                 checkColor:(UIColor *)checkColor
                                 checkWidth:(CGFloat)checkWidth
                              completeBlock:(DRLayerAnimationCompleteBlock)completeBlock {
    return [self checkAnimationLayerWithRect:rect
                                  checkColor:checkColor
                                  checkWidth:checkWidth
                                    duration:kDRAnimationDuration
                               completeBlock:completeBlock];
}

@end


@implementation CAGradientLayer (DRExtension)

/// 从上到下渐变图层
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                              topColor:(UIColor *)topColor
                           bottomColor:(UIColor *)bottomColor
                          cornerRadius:(CGFloat)cornerRadius {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
    layer.colors = @[(__bridge id)topColor.CGColor, (__bridge id)bottomColor.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(0, 1.0);
    return layer;
}
/// 从右到左渐变
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                             leftColor:(UIColor *)leftColor
                            rightColor:(UIColor *)rightColor
                          cornerRadius:(CGFloat)cornerRadius {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.cornerRadius = cornerRadius;
    layer.masksToBounds = YES;
    layer.colors = @[(__bridge id)leftColor.CGColor, (__bridge id)rightColor.CGColor];
    layer.locations = @[@0.0, @1.0];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1.0, 0.0);
    return layer;
}

@end
