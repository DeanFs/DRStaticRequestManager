//
//  CALayer+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/6.
//

#import <QuartzCore/QuartzCore.h>

typedef void (^DRLayerAnimationCompleteBlock)(CALayer *layer);

@interface CALayer (DRExtension)

- (void)setBorderUIColor:(UIColor*)color;
- (UIColor*)borderUIColor;

/**
 构建圆圈layer

 @param rect 大小及位置
 @param color 圆圈颜色
 @param borderWidth 圆圈线宽
 @return 返回圆圈layer
 */
+ (instancetype)circleBorderLayerWithRect:(CGRect)rect
                                    color:(UIColor *)color
                              borderWidth:(CGFloat)borderWidth;

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
                       cornerRadius:(CGFloat)cornerRadius;

/**
 构建圆形纯色layer

 @param rect 大小及位置
 @param color 背景颜色
 @return layer
 */
+ (instancetype)circlePureColorLayerWithRect:(CGRect)rect
                                       color:(UIColor *)color;

/**
 构建矩形、圆角纯色layer
 
 @param rect 大小及位置
 @param color 背景颜色
 @param cornerRadius 圆角半径
 @return layer
 */
+ (instancetype)pureColorLayerWithRect:(CGRect)rect
                                 color:(UIColor *)color
                          cornerRadius:(CGFloat)cornerRadius;

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
                                     borderWidth:(CGFloat)borderWidth;

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
                                    backgroundColor:(UIColor *)backgroundColor;

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
                                   progress:(CGFloat)progress;

#pragma mark - 渐变图层
/// 从上到下渐变图层
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                              topColor:(UIColor *)topColor
                           bottomColor:(UIColor *)bottomColor
                          cornerRadius:(CGFloat)cornerRadius;
/// 从右到左渐变
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                             leftColor:(UIColor *)leftColor
                            rightColor:(UIColor *)rightColor
                          cornerRadius:(CGFloat)cornerRadius;

@end


@interface CALayer (DRAnimation)
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
                                            completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

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
                                              completeBolock:(DRLayerAnimationCompleteBlock)completeBlock;

/**
 圆圈进度动画，当进度为1时在中心执行打勾动画
 
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
                                       completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

#pragma mark - 放大缩小动画
- (void)addScaleAnimationWithCompleteBlock:(DRLayerAnimationCompleteBlock)completeBlock;
- (void)addScaleAnimationWithDuration:(CGFloat)duration
                        completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

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
                              completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

@end


@interface CAShapeLayer (DRExtension)

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
                             bezierPath:(UIBezierPath *)path;

/**
 构建打勾图层
 
 @param rect 勾显示大小，有固定比例内边距，不会撑满size
 @param checkColor 勾显示颜色
 @param checkWidth 勾宽度
 @return 打勾图层layer
 */
+ (instancetype)checkLayerWithRect:(CGRect)rect
                        checkColor:(UIColor *)checkColor
                        checkWidth:(CGFloat)checkWidth;

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
                                 toProgress:(CGFloat)toProgress;

@end


@interface CAShapeLayer (DRAnimation)

/**
 添加路径绘制动画，动画填充指定的path
 
 @param completeBlock 动画完成回调
 */
- (void)addStrokeAnimationWithCompleteBlock:(DRLayerAnimationCompleteBlock)completeBlock;

/**
 添加路径绘制动画，动画填充指定的path
 
 @param duration 动画时长
 @param completeBlock 动画完成回调
 */
- (void)addStrokeAnimationWithDuration:(CGFloat)duration
                         completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

#pragma mark - 打勾动画
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
                              completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

@end


@interface CAGradientLayer (DRExtension)

/// 从上到下渐变图层
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                              topColor:(UIColor *)topColor
                           bottomColor:(UIColor *)bottomColor
                          cornerRadius:(CGFloat)cornerRadius;
/// 从右到左渐变
+ (instancetype)gradientLayerWithFrame:(CGRect)frame
                             leftColor:(UIColor *)leftColor
                            rightColor:(UIColor *)rightColor
                          cornerRadius:(CGFloat)cornerRadius;


@end
