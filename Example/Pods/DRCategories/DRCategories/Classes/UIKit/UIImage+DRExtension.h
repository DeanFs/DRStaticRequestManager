//
//  UIImage+DRExtension.h
//  Records
//
//  Created by Zube on 2017/11/3.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DRExtension)

#pragma mark - 创建图片

/**
 创建纯色图片
 size:(1,1)

 @param color 图片颜色
 @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 创建纯色图片
 size:(screenWidth, 0.25)

 @param color 图片颜色
 @return 返回图片
 */
+ (UIImage *)navigationShadowImageWithColor:(UIColor *)color;

/**
 创建纯色图片

 @param color 图片颜色
 @param size 图片尺寸
 @param cornerRadius 图片圆角半径
 @return 返回图片
 */
+ (UIImage *)pureImageWithColor:(UIColor *)color
                           size:(CGSize)size
                   cornerRadius:(CGFloat)cornerRadius;

/**
 将layer绘制成图片

 @param layer 要绘制的layer
 @return 返回图片
 */
+ (UIImage *)imageFromLayer:(CALayer *)layer;

/**
 将view绘制成图片

 @param view 要绘制成图片的UIview
 @return 返回图片
 */
+ (UIImage *)imageFromView:(UIView *)view;

/**
 给icon设置圆形背景色，大小和圆角生成新图片
 
 @param icon 待合成图片
 @param color 待添加的背景色
 @param size 生成图片的尺寸
 @return 返回新图片
 */
+ (UIImage *)circleDrawSimpleIcon:(UIImage *)icon
                inBackgroundColor:(UIColor *)color
                         withSize:(CGSize)size;

/**
 给icon设置背景色，大小和圆角生成新图片

 @param icon 待合成图片
 @param color 待添加的背景色
 @param size 生成图片的尺寸
 @param cornerRadius 图片圆角
 @return 返回新图片
 */
+ (UIImage *)drawSimpleIcon:(UIImage *)icon
          inBackgroundColor:(UIColor *)color
                   withSize:(CGSize)size
               cornerRadius:(CGFloat)cornerRadius;

/**
 创建圆圈图片

 @param color 圆圈颜色
 @param size 圆圈大小
 @param borderWidth 圆圈线宽
 @return 返回圆圈图片
 */
+ (UIImage *)circleBorderImageWithColor:(UIColor *)color
                                   size:(CGSize)size
                            borderWidth:(CGFloat)borderWidth;


/**
 构建圆圈中带勾的图片

 @param size 圆圈大小
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param borderColor 圆圈颜色
 @param borderWidth 圆圈宽度
 @return 返回图片
 */
+ (UIImage *)checkInCircleBorderImageWithSize:(CGSize)size
                                   checkColor:(UIColor *)checkColor
                                   checkWidth:(CGFloat)checkWidth
                                  borderColor:(UIColor *)borderColor
                                  borderWidth:(CGFloat)borderWidth;

/**
 构建纯色圆圈背景中带勾的图片

 @param size 纯色圆圈背景大小
 @param checkColor 勾线条颜色
 @param checkWidth 勾线条宽度
 @param backgroundColor 纯色背景
 @return 返回图片
 */
+ (UIImage *)checkInCirclePureColorImageWithSize:(CGSize)size
                                      checkColor:(UIColor *)checkColor
                                      checkWidth:(CGFloat)checkWidth
                                 backgroundColor:(UIColor *)backgroundColor;

/**
 圆圈进度图片

 @param size 圆圈大小
 @param progressColor 进图条颜色
 @param trackColor 进度底色
 @param strokeWidth 进度条宽度
 @param progress 进度值
 @return 返回图片
 */
+ (UIImage *)circleProgressImageWithSize:(CGSize)size
                           progressColor:(UIColor *)progressColor
                              trackColor:(UIColor *)trackColor
                             strokeWidth:(CGFloat)strokeWidth
                                progress:(CGFloat)progress;

/**
 构建勾图片

 @param size 勾外围尺寸
 @param lineWidth 勾线条宽度
 @param lineColor 勾线条颜色
 @return 勾图片
 */
+ (UIImage *)checkLineImageWithSize:(CGSize)size
                          lineWidth:(CGFloat)lineWidth
                          lineColor:(UIColor *)lineColor;

#pragma mark - 按scale比例截取屏幕
+ (UIImage *)screenshot; // scale = 0.0，截出屏幕大小的图
+ (UIImage *)screenshotWithScale:(float)scale;

#pragma mark - utils
// 按比例压缩图片大小
- (UIImage*)compressWithScale:(CGFloat)scale;
// 更改图片颜色
- (UIImage *)changeColorTo:(UIColor *)color;

#pragma mark - Cache
// 缓存图片到沙盒
+ (UIImage *)imageForKey:(NSString *)key;
// 从沙盒获取图片
+ (void)cacheImage:(UIImage *)image forKey:(NSString *)key;
// 清空沙盒中的缓存
+ (void)cleanCache;

@end


#pragma mark - 加水印
@interface UIImage (DRWaterMark)

/**
 *  给图片加水印图片
 *
 *  @param image   水印图片
 *  @param imgRect 水印图片所在位置，大小
 *  @param alpha   水印图片的透明度，0~1之间，透明度太大会完全遮盖被加水印图片的那一部分
 *
 *  @return 加完水印的图片
 */
- (UIImage*)imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha;
/**
 *  同上
 *
 *  @param image    同上
 *  @param imgPoint 水印图片（0，0）所在位置
 *  @param alpha    同上
 *
 *  @return 同上
 */
- (UIImage*)imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha;

/**
 *  给图片加文字水印
 *
 *  @param str     水印文字
 *  @param strRect 文字所在的位置大小
 *  @param attri   文字的相关属性，自行设置
 *
 *  @return 加完水印文字的图片
 */
- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri;
/**
 *  同上
 *
 *  @param str      同上
 *  @param strPoint 文字（0，0）点所在位置
 *  @param attri    同上
 *
 *  @return 同上
 */
- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri;
/**
 *  返回加水印文字和图片的图片
 *
 *  @param str      水印文字
 *  @param strPoint 文字（0，0）点所在位置
 *  @param attri    文字属性
 *  @param image    水印图片
 *  @param imgPoint 图片（0，0）点所在位置
 *  @param alpha    透明度
 *
 *  @return 加完水印的图片
 */
- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha;
/**
 *  同上
 *
 *  @param str     同上
 *  @param strRect 文字的位置大小
 *  @param attri   同上
 *  @param image   同上
 *  @param imgRect 图片的位置大小
 *  @param alpha   透明度
 *
 *  @return 同上
 */
- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha;

@end
