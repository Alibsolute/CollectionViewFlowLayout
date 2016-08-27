//
//  CollectionViewLayout.h
//  CollectionViewFlowLayout
//
//  Created by ABS on 16/3/15.
//  Copyright © 2016年 abs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewLayout;
@protocol CollectionViewLayoutDelegate <UICollectionViewDelegateFlowLayout>
- (CGFloat)collection:(UICollectionView *)collectionView layout:(CollectionViewLayout *)layout heightForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface CollectionViewLayout : UICollectionViewFlowLayout

@property (nonatomic,weak) id<CollectionViewLayoutDelegate> delegate;

@property (nonatomic,assign) NSUInteger numberOfColumns;
@property (nonatomic,assign) CGFloat interItemSpacing;

@end
