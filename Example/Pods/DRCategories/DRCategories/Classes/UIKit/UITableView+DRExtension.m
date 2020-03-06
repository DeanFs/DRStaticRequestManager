//
//  UITableView+DRExtension.m
//  Records
//
//  Created by admin on 2017/11/7.
//  Copyright © 2017年 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UITableView+DRExtension.h"

@implementation UITableView (DRExtension)

/*
 使用nib来注册cell对象
 */
- (void)registerNib:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:nibName];
}

/*
 使用nib来注册header对象
 */
- (void)registerHeaderNib:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forHeaderFooterViewReuseIdentifier:nibName];
}

/*
 使用nib来注册footer对象
 */
- (void)registerFooterNib:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forHeaderFooterViewReuseIdentifier:nibName];
}

/**
 初始化tableView
 预估高度0
 设置footer去掉多余线条
 设置代理
 iOS11以上设置adjustmentBehavior未never
 
 @param delegate 代理
 */
- (void)setupWithDelegate:(id<UITableViewDelegate, UITableViewDataSource>)delegate {
    self.delegate = delegate;
    self.dataSource = delegate;
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    self.tableFooterView = [[UIView alloc] init];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end


@implementation UITableViewCell (DRExtension)

+ (CGFloat)cellHeight {
    return 44.0;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end
