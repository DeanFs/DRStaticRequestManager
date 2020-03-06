//
//  UIView+DRExtension.h
//  DRBasicKit
//
//  Created by 冯生伟 on 2019/3/6.
//

#import <UIKit/UIKit.h>
#import "CALayer+DRExtension.h"

#pragma mark - 快速获取和设置Frame信息
@interface UIView (DRExtension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;

/**
 指定边角设置圆角，需要在视图加载完成后调用

 @param corners 指定边角
 @param cornerRadius 圆角半径
 */
- (void)addRoundingCorners:(UIRectCorner)corners cornerRadius:(CGFloat)cornerRadius;

/**
 检测视图内是否有正在滚动的视图

 @param view 待检测视图
 @return YES：有正在滚动的视图，NO：没有
 */
- (BOOL)anySubViewScrolling:(UIView *)view;

@end


#pragma mark - 动画
@interface UIView (DRAnimation)

+ (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)animationCurve;

/*
 放大弹簧的动画
 */
- (void)springScaleAnimateShow;

/*
 关闭动画
 */
- (void)dismissView;

/*
 透明动画
 */
- (void)animateWithAlpha:(CGFloat)alpha;

/*
 平移动画
 */
- (void)translateAnimateFromPoint:(CGPoint)fromPt;

/*
 平移动画带回调
 注意循环引用问题
 */
- (void)translateAnimateFromPoint:(CGPoint)fromPt
                         complete:(void (^)(BOOL finish))complete;


/**
 中心发散波纹动画
 
 @param radarColor 扩散颜色
 @param radarBorderColor 扩散边界颜色
 @param toValue 扩散半径倍率
 @return 返回动画图层
 */
- (CALayer *)addHighlightAnimationWithRadarColor:(UIColor *)radarColor
                                radarBorderColor:(UIColor *)radarBorderColor
                                         toValue:(CGFloat)toValue;

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
                                    pulsingCount:(NSInteger)pulsingCount;

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
                     completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

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
                                       completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

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
 */
- (void)addCircleProgressAnimationLayerWithRect:(CGRect)rect
                                  progressColor:(UIColor *)progressColor
                                     trackColor:(UIColor *)trackColor
                                    strokeWidth:(CGFloat)strokeWidth
                                currentProgress:(CGFloat)currentProgress
                                     toProgress:(CGFloat)toProgress
                                  completeBlock:(DRLayerAnimationCompleteBlock)completeBlock;

@end


#pragma mark - 渐变色
@interface UIView (DRLayerGradient)

// 从上到下
- (CAGradientLayer *)setGradientFromTopColor:(UIColor *)fromColor
                               toBottomColor:(UIColor *)toColor;
// 从上到下加圆角
- (CAGradientLayer *)setGradientFromTopColor:(UIColor *)fromColor
                               toBottomColor:(UIColor *)toColor
                                cornerRadius:(CGFloat)cornerRadius;

// 从左到右
- (CAGradientLayer *)setGradientFromLeftColor:(UIColor *)fromColor
                                 toRightColor:(UIColor *)toColor;
// 从左到右加圆角
- (CAGradientLayer *)setGradientFromLeftColor:(UIColor *)fromColor
                                 toRightColor:(UIColor *)toColor
                                 cornerRadius:(CGFloat)cornerRadius;


@end
