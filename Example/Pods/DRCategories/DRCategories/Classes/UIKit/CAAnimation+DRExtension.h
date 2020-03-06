//
//  CAAnimation+DRExtension.h
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/4.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DRKeyAnimationCompleteBlock)(CAAnimation *animation, BOOL finished);

@interface CAAnimation (DRExtension) <CAAnimationDelegate>

@property (nonatomic, copy) DRKeyAnimationCompleteBlock completeBlock;

/**
 构建关键帧动画

 @param keyPath 动画属性
 @param values 关键帧值
 @param duration 动画时长
 @param repeatCount 重复次数
 @param removedOnCompletion 动画结束时移除动画
 @param completeBlock 动画完成回调
 @return 返回关键帧动画
 */
+ (CAKeyframeAnimation *)keyframeAnimationWithKeyPath:(NSString *)keyPath
                                               values:(NSArray *)values
                                             duration:(CGFloat)duration
                                          repeatCount:(NSInteger)repeatCount
                                  removedOnCompletion:(BOOL)removedOnCompletion
                                        completeBlock:(DRKeyAnimationCompleteBlock)completeBlock;

@end

NS_ASSUME_NONNULL_END
