//
//  ABSWaterFlowLayout.h
//  UICollection 流水布局
//
//  Created by ABS on 15/10/5.
//  Copyright © 2015年 Abson. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ABSWaterFlowLayout;
@protocol ABSWaterFlowLayoutDelegate <NSObject>

- (CGFloat)waterflowLayout:(ABSWaterFlowLayout *)waterflowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ABSWaterFlowLayout : UICollectionViewLayout

/** 每一列的间距*/
@property (nonatomic, assign) NSInteger columnMargin;
/** 每一行的间距*/
@property (nonatomic, assign) NSInteger rowMargin;
/** 每一组的间距*/
@property (nonatomic, assign) UIEdgeInsets sectionInset;
/** 有多少列*/
@property (nonatomic, assign) NSInteger coloumnsCount;

@property (nonatomic, weak) id<ABSWaterFlowLayoutDelegate> delegate;

@end
