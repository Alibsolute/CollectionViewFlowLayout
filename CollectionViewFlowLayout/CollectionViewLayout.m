//
//  CollectionViewLayout.m
//  CollectionViewFlowLayout
//
//  Created by ABS on 16/3/15.
//  Copyright © 2016年 abs. All rights reserved.
//

#import "CollectionViewLayout.h"

@interface CollectionViewLayout ()
@property (nonatomic,strong) NSMutableDictionary *lastYValueForColum;
@property (nonatomic,strong) NSMutableDictionary *layoutInfo;
@end

@implementation CollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.numberOfColumns = 2;
        self.interItemSpacing = 10;
        self.lastYValueForColum = [NSMutableDictionary dictionary]; //用于记录item的y坐标
        self.layoutInfo = [NSMutableDictionary dictionary];         //用于记录item的属性

    }
    return self;
}

- (void)prepareLayout {
    
    //初始化当前item为第0个item
    CGFloat currentColumn = 0;
    
    //计算item的宽度
    CGFloat fullWidth = self.collectionView.frame.size.width;
    CGFloat availableSpaceExcludingPadding = fullWidth - (self.interItemSpacing * (self.numberOfColumns + 1));
    CGFloat itemWidth = availableSpaceExcludingPadding / self.numberOfColumns;
    
    NSIndexPath *indexPath;
    NSInteger numSections = [self.collectionView numberOfSections];
    //遍历section
    for (NSInteger section=0; section<numSections; section++) {
        
        //遍历item
        NSInteger numItems = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger item=0; item<numItems; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            //计算x坐标
            CGFloat x = self.interItemSpacing + (self.interItemSpacing + itemWidth) * currentColumn;
            //计算y坐标
            CGFloat y = [self.lastYValueForColum[@(currentColumn)] doubleValue];
            if (y == 0) {
                y = y + self.interItemSpacing;
            }
            //通过协议回传高度值
            CGFloat itemheight = [(id<CollectionViewLayoutDelegate>)self.delegate collection:self.collectionView
                                                                                      layout:self
                                                                    heightForItemAtIndexPath:indexPath];
            itemAttributes.frame = CGRectMake(x, y, itemWidth, itemheight);
            
            //下一个item的y轴是当前y坐标加上item高度，并且加上间距
            y = y + itemheight + self.interItemSpacing;
            
            //把下一个item的y坐标计入到字典中
            self.lastYValueForColum[@(currentColumn)] = @(y);
            
            currentColumn++;
            if (currentColumn == self.numberOfColumns) {
                currentColumn = 0;
            }
            
            //将item的属性记录到字典中
            self.layoutInfo[indexPath] = itemAttributes;
        }
        
        
    }
}

//使用enumerateKeysAndObjectsUsingBlock遍历prepareLayout中的layoutInfo加入一个数组中
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL * _Nonnull stop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    return allAttributes;
}

- (CGSize)collectionViewContentSize {
    NSUInteger currentColumn = 0;
    CGFloat maxHeight = 0;
    do {
        //最大高度就是之前字典中的y坐标
        CGFloat height = [self.lastYValueForColum[@(currentColumn)] doubleValue];
        if(height > maxHeight)
            maxHeight = height;
        currentColumn ++;
    } while (currentColumn < self.numberOfColumns);
    
    return CGSizeMake(self.collectionView.frame.size.width, maxHeight);
}

@end

































