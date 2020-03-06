//
//  UICollectionView+DRExtension.h
//  Records
//
//  Created by DuoRong on 2019/1/3.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (DRExtension)

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

/*
 使用nib来出栈cell
 */
- (id)dequeueCell:(NSString *)nibName
        indexPath:(NSIndexPath *)indexPath;

/*
 使用nib来出栈header对象
 */
- (id)dequeueHeader:(NSString *)nibName
          indexPath:(NSIndexPath *)indexPath;

/*
 使用nib来出栈footer对象
 */
- (id)dequeueFooter:(NSString *)nibName
          indexPath:(NSIndexPath *)indexPath;
@end


@interface UICollectionViewCell (DRExtension)

+ (CGSize)cellSize;
+ (NSString *)cellIdentifier;

@end


@interface UICollectionReusableView (DRExtension)

+ (CGFloat)viewHeight;
+ (NSString *)viewIdentifier;

@end

NS_ASSUME_NONNULL_END
