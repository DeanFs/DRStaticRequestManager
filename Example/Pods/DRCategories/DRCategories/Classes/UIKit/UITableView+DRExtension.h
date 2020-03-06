//
//  UITableView+DRExtension.h
//  Records
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (DRExtension)

/*
 使用nib来注册cell对象
 */
- (void)registerNib:(NSString *)nibName;

/*
 使用nib来注册header对象
 */
- (void)registerHeaderNib:(NSString *)nibName;

/*
 使用nib来注册footer对象
 */
- (void)registerFooterNib:(NSString *)nibName;

/**
 初始化tableView
 预估高度0
 设置footer去掉多余线条
 设置代理
 iOS11以上设置adjustmentBehavior未never

 @param delegate 代理
 */
- (void)setupWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate;

@end


@interface UITableViewCell (DRExtension)

+ (CGFloat)cellHeight;
+ (NSString *)cellIdentifier;

@end
