//
//  UIBarButtonItem+DRExtension.m
//  Records
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UIBarButtonItem+DRExtension.h"

@implementation UIBarButtonItem (DRExtension)

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(NSString *)image
                       target:(id)target
                       action:(SEL)action {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    UIImage *img=[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:img forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
   // [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}

@end
