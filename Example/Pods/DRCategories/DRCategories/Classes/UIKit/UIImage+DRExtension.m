//
//  UIImage+DRExtension.m
//  Records
//
//  Created by Zube on 2017/11/3.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UIImage+DRExtension.h"
#import <DRMacroDefines/DRMacroDefines.h>
#import <DRSandboxManager/DRSandboxManager.h>
#import "CALayer+DRExtension.h"

@implementation UIImage (DRExtension)

#pragma mark - 创建图片
/**
 创建纯色图片
 size:(1,1)
 
 @param color 图片颜色
 @return 返回图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self pureImageWithColor:color
                               size:CGSizeMake(1.0f, 1.0f)
                       cornerRadius:0];
}

/**
 创建纯色图片
 size:(screenWidth, 0.25)
 
 @param color 图片颜色
 @return 返回图片
 */
+ (UIImage *)navigationShadowImageWithColor:(UIColor *)color {
    return [self pureImageWithColor:color
                               size:CGSizeMake(kDRScreenWidth, 0.25f)
                       cornerRadius:0];
}

/**
 创建纯色图片
 
 @param color 图片颜色
 @param size 图片尺寸
 @param cornerRadius 图片圆角半径
 @return 返回图片
 */
+ (UIImage *)pureImageWithColor:(UIColor *)color
                           size:(CGSize)size
                   cornerRadius:(CGFloat)cornerRadius {
    NSString *key = [NSString stringWithFormat:@"%@%@%f", [self rgbaStringFromColor:color], NSStringFromCGSize(size), cornerRadius];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer pureColorLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                   color:color
                                            cornerRadius:cornerRadius];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 将layer绘制成图片
 
 @param layer 要绘制的layer
 @return 返回图片
 */
+ (UIImage *)imageFromLayer:(CALayer *)layer {
    UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}

/**
 将view绘制成图片
 
 @param view 要绘制成图片的UIview
 @return 返回图片
 */
+ (UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:true];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 给icon设置圆形背景色，大小和圆角生成新图片
 
 @param icon 待合成图片
 @param color 待添加的背景色
 @param size 生成图片的尺寸
 @return 返回新图片
 */
+ (UIImage *)circleDrawSimpleIcon:(UIImage *)icon
                inBackgroundColor:(UIColor *)color
                         withSize:(CGSize)size {
    return [self drawSimpleIcon:icon
              inBackgroundColor:color
                       withSize:size
                   cornerRadius:size.width/2];
}

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
               cornerRadius:(CGFloat)cornerRadius {
    CALayer *containerLayer = [CALayer layer];
    containerLayer.frame = CGRectMake(0, 0, size.width, size.height);
    containerLayer.cornerRadius = cornerRadius;
    containerLayer.masksToBounds = YES;
    containerLayer.backgroundColor = color.CGColor;
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake((size.width-icon.size.width)/2,
                                  (size.height-icon.size.height)/2,
                                  icon.size.width,
                                  icon.size.height);
    imageLayer.contents = (__bridge id)icon.CGImage;
    imageLayer.contentsGravity = kCAGravityResizeAspect;
    [containerLayer addSublayer:imageLayer];
    return [self imageFromLayer:containerLayer];
}

/**
 创建圆圈图片
 
 @param color 圆圈颜色
 @param size 圆圈大小
 @param borderWidth 圆圈线宽
 @return 返回圆圈图片
 */
+ (UIImage *)circleBorderImageWithColor:(UIColor *)color
                                   size:(CGSize)size
                            borderWidth:(CGFloat)borderWidth {
    NSString *key = [NSString stringWithFormat:@"%@%@%f", [self rgbaStringFromColor:color], NSStringFromCGSize(size), borderWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer circleBorderLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                      color:color
                                                borderWidth:borderWidth];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

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
                                  borderWidth:(CGFloat)borderWidth {
    NSString *key = [NSString stringWithFormat:@"check_circleb_%@%@%@%f%f", [self rgbaStringFromColor:checkColor], [self rgbaStringFromColor:borderColor], NSStringFromCGSize(size), checkWidth, borderWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer checkInCircleBorderLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                        checkColor:checkColor
                                                        checkWidth:checkWidth
                                                       borderColor:borderColor
                                                       borderWidth:borderWidth];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

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
                                 backgroundColor:(UIColor *)backgroundColor {
    NSString *key = [NSString stringWithFormat:@"check_circlep_%@%@%@%f", [self rgbaStringFromColor:checkColor], [self rgbaStringFromColor:backgroundColor], NSStringFromCGSize(size), checkWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer checkInCirclePureColorLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                           checkColor:checkColor
                                                           checkWidth:checkWidth
                                                      backgroundColor:backgroundColor];
        image = [self imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

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
                                progress:(CGFloat)progress {
    NSString *key = [NSString stringWithFormat:@"circle_pregress_%@%@%@%f%f", [self rgbaStringFromColor:progressColor], [self rgbaStringFromColor:trackColor], NSStringFromCGSize(size), strokeWidth, progress];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CALayer *layer = [CALayer circleProgressLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                progressColor:progressColor
                                                   trackColor:trackColor
                                                  strokeWidth:strokeWidth
                                                     progress:progress];
        image = [UIImage imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

/**
 构建勾图片
 
 @param size 勾外围尺寸
 @param lineWidth 勾线条宽度
 @param lineColor 勾线条颜色
 @return 勾图片
 */
+ (UIImage *)checkLineImageWithSize:(CGSize)size
                          lineWidth:(CGFloat)lineWidth
                          lineColor:(UIColor *)lineColor {
    NSString *key = [NSString stringWithFormat:@"check_line_%@%@%f", [self rgbaStringFromColor:lineColor], NSStringFromCGSize(size), lineWidth];
    UIImage *image = [self imageForKey:key];
    if (!image) {
        CAShapeLayer *layer = [CAShapeLayer checkLayerWithRect:CGRectMake(0, 0, size.width, size.height)
                                                    checkColor:lineColor
                                                    checkWidth:lineWidth];
        image = [UIImage imageFromLayer:layer];
        [self cacheImage:image forKey:key];
    }
    return image;
}

#pragma mark - 按scale比例截取屏幕
// scale = 0.0
+ (UIImage *)screenshot {
    return [UIImage screenshotWithScale:0.0f];
}

+ (UIImage *)screenshotWithScale:(float)scale {
    CGSize imageSize = [UIScreen mainScreen].bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - utils
//按比例压缩图片大小
- (UIImage*)compressWithScale:(CGFloat)scale {
    CGSize size = self.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  更改图片颜色
 *
 *  @param color 填充色
 *
 *  @return UIImage
 */
- (UIImage *)changeColorTo:(UIColor *)color {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Cache
+ (UIImage *)imageForKey:(NSString *)key {
    return [UIImage imageWithContentsOfFile:[self imageCachePathForKey:key]];
}

+ (void)cacheImage:(UIImage *)image forKey:(NSString *)key {
    BOOL result = [UIImagePNGRepresentation(image) writeToFile:[self imageCachePathForKey:key]
                                                    atomically:YES];
    if (result) {
        kDR_LOG(@"图片保存成功");
    }
}

+ (void)cleanCache {
    [DRSandBoxManager getDirectoryInDocumentWithName:@"DRBasicKit/ImageCache" doneBlock:^(BOOL success, NSError * _Nonnull error, NSString * _Nonnull dirPath) {
        [DRSandBoxManager deleteFileAtPath:dirPath
                                 doneBlock:^(NSString * _Nonnull filePath, BOOL success, NSError * _Nonnull error) {
                                     if (success) {
                                         kDR_LOG(@"已清除图片缓存");
                                     }
                                 }];
    }];
}

#pragma mark - private
+ (NSString *)imageCachePathForKey:(NSString *)key {
    __block NSString *cachePath;
    [DRSandBoxManager getFilePathWithName:[NSString stringWithFormat:@"icon_%@@%dx.png", key, (int)[UIScreen mainScreen].scale]
                                    inDir:@"DRBasicKit/ImageCache"
                                doneBlock:^(NSError * _Nonnull error, NSString * _Nonnull filePath) {
                                    if (!error && filePath) {
                                        cachePath = filePath;
                                    }
                                }];
    return cachePath;
}

+ (NSString *)rgbaStringFromColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    CGFloat rgba[4];
    [color getRed:&rgba[0] green:&rgba[1] blue:&rgba[2] alpha:&rgba[3]];
    NSMutableString *rgbaStr = [NSMutableString string];
    for (NSInteger i=0; i<4; i++) {
        [rgbaStr appendFormat:@"%@", @(rgba[i]).stringValue];
    }
    return [rgbaStr stringByReplacingOccurrencesOfString:@"." withString:@""];
}

@end


@implementation UIImage (DRWaterMark)

- (UIImage*)imageWaterMarkWithImage:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil rect:CGRectZero attribute:nil image:image imageRect:imgRect alpha:alpha];
}

- (UIImage*)imageWaterMarkWithImage:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    return [self imageWaterMarkWithString:nil point:CGPointZero attribute:nil image:image imagePoint:imgPoint alpha:alpha];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri
{
    return [self imageWaterMarkWithString:str rect:strRect attribute:attri image:nil imageRect:CGRectZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri
{
    return [self imageWaterMarkWithString:str point:strPoint attribute:attri image:nil imagePoint:CGPointZero alpha:0];
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str point:(CGPoint)strPoint attribute:(NSDictionary*)attri image:(UIImage*)image imagePoint:(CGPoint)imgPoint alpha:(CGFloat)alpha
{
    // 开启和原图一样大小的上下文（保证图片不模糊的方法）
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    [self drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawAtPoint:imgPoint blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawAtPoint:strPoint withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
    
}

- (UIImage*)imageWaterMarkWithString:(NSString*)str rect:(CGRect)strRect attribute:(NSDictionary *)attri image:(UIImage *)image imageRect:(CGRect)imgRect alpha:(CGFloat)alpha
{
    // 开启和原图一样大小的上下文（保证图片不模糊的方法）
    UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    if (image) {
        [image drawInRect:imgRect blendMode:kCGBlendModeNormal alpha:alpha];
    }
    
    if (str) {
        [str drawInRect:strRect withAttributes:attri];
    }
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
