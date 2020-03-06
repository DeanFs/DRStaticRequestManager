//
//  CAAnimation+DRExtension.m
//  AFNetworking
//
//  Created by 冯生伟 on 2019/4/4.
//

#import "CAAnimation+DRExtension.h"
#import <objc/runtime.h>
#import <DRMacroDefines/DRMacroDefines.h>

static NSString *kCompleteBlock = @"animationCompleteBlock";

@implementation CAAnimation (DRExtension)

@dynamic completeBlock;

- (void)setCompleteBlock:(DRKeyAnimationCompleteBlock)completeBlock {
    objc_setAssociatedObject(self, &kCompleteBlock, completeBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DRKeyAnimationCompleteBlock)completeBlock {
    return objc_getAssociatedObject(self, &kCompleteBlock);
}

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
                                        completeBlock:(DRKeyAnimationCompleteBlock)completeBlock {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.values = values;
    animation.duration = duration;
    animation.repeatCount = repeatCount;
    animation.removedOnCompletion = removedOnCompletion;
    animation.delegate = animation;
    animation.completeBlock = completeBlock;
    return animation;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    kDR_SAFE_BLOCK(self.completeBlock, anim, flag);
}

@end
