//
//  UIFont+DRExtentsion.m
//  Records
//
//  Created by admin on 2018/11/14.
//  Copyright © 2018年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UIFont+DRExtentsion.h"

@implementation UIFont (DRExtentsion)

+ (UIFont *)dr_PingFangSC_RegularWithSize:(CGFloat)fontSize {
    return  [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

+ (UIFont *)dr_PingFangSC_MediumWithSize:(CGFloat)fontSize {
    return  [UIFont fontWithName:@"PingFang-SC-Medium" size:fontSize];
}

+ (UIFont *)dr_PingFangSC_LightWithSize:(CGFloat)fontSize {
    return  [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
}


@end
