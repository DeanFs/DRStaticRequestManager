//
//  UIBarButtonItem+DRExtension.h
//  Records
//
//  Created by admin on 2017/12/8.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DRExtension)

+ (instancetype)itemWithTitle:(NSString *)title
                        image:(NSString *)image
                       target:(id)target action:(SEL)action;

@end
