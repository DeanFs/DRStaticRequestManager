//
//  UICollectionView+DRExtension.m
//  Records
//
//  Created by DuoRong on 2019/1/3.
//  Copyright © 2019 DuoRong Technology Co., Ltd. All rights reserved.
//

#import "UICollectionView+DRExtension.h"

@implementation UICollectionView (DRExtension)

- (void)registerNib:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil]
          forCellWithReuseIdentifier:nibName];
}

/*
 使用nib来注册header对象
 */
- (void)registerHeaderNib:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:nibName];
}

/*
 使用nib来注册footer对象
 */
- (void)registerFooterNib:(NSString *)nibName {
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                 withReuseIdentifier:nibName];
}

/*
 使用nib来出栈cell
 */
- (id)dequeueCell:(NSString *)nibName
                            indexPath:(NSIndexPath *)indexPath{
    return [self dequeueReusableCellWithReuseIdentifier:nibName
                                           forIndexPath:indexPath];
}

/*
 使用nib来出栈header对象
 */
- (id)dequeueHeader:(NSString *)nibName
            indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                       withReuseIdentifier:nibName
                                           forIndexPath:indexPath];
}

/*
 使用nib来出栈footer对象
 */
- (id)dequeueFooter:(NSString *)nibName
                                  indexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                    withReuseIdentifier:nibName
                                           forIndexPath:indexPath];
}

@end


@implementation UICollectionViewCell (DRExtension)

+ (CGSize)cellSize {
    return CGSizeZero;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

@end


@implementation UICollectionReusableView (DRExtension)

+ (CGFloat)viewHeight {
    return 0;
}

+ (NSString *)viewIdentifier {
    return NSStringFromClass([self class]);
}

@end
