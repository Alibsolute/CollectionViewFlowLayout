//
//  ABSWaterFlowLayout.m
//  UICollection 流水布局
//
//  Created by ABS on 15/10/5.
//  Copyright © 2015年 Abson. All rights reserved.
//

/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) {\
    if (nil != (__REF)) {\
        __REF = nil;\
    }\
}

#import "ABSWaterFlowLayout.h"

@interface ABSWaterFlowLayout()
/** 这个字典用来存储每一列最大的 Y 值(每一列的高度)*/
@property (nonatomic,strong) NSMutableDictionary *maxDict;

@property (nonatomic,strong) NSMutableArray  *attrsArray;
@end

@implementation ABSWaterFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.columnMargin = 10;
        self.rowMargin = 10;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.coloumnsCount = 2;
    }
    return self;
}

- (void)dealloc {
    TT_RELEASE_SAFELY(self.maxDict);
    TT_RELEASE_SAFELY(self.attrsArray);
    
}


// 准备布局的时候先调用这个方法
/**
 *  需要在这个方法中计算边框，需要计算每个item的frame的值，并把他存入字典的layoutInfo中
    然后,在我们覆盖父类的方法layoutAttributesElementsInRect中
    可以返回资格字典中的全部frame总值的数组
 */
- (void)prepareLayout {
    [super prepareLayout];
    
    for (int i = 0; i < self.coloumnsCount; i ++) {
        NSString *column = [NSString stringWithFormat:@"%d",i];
        self.maxDict[column] = @(0);
    }
    
    [self.attrsArray removeAllObjects];
    // 第0组的 item 的数量
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [self.attrsArray addObject:attrs];
        TT_RELEASE_SAFELY(attrs);
    }
}


// 返回所有尺寸
- (CGSize)collectionViewContentSize {
    __block NSString *maxColumn = @"0";
    [self.maxDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *obj, BOOL * _Nonnull stop) {
        if (self.maxDict[column] > self.maxDict[maxColumn] ) {
            maxColumn = column;
        }
    }];
    return CGSizeMake(0, [self.maxDict[maxColumn] floatValue]);
}

// 为indexPath 位置中的 cell 返回一个布局属性，告诉这个 cell 改放在哪一个位置(frame)
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 假设最短的那一列是第0列
    __block NSString *minColum = @"0";
    // 找出最短的那一列
    [self.maxDict enumerateKeysAndObjectsUsingBlock:^(NSString *column, NSNumber *maxY, BOOL * _Nonnull stop) {
        if ([maxY floatValue] < [self.maxDict[minColum] floatValue]) {
            minColum = column;
        }
    }];
    
    // 计算宽度
    CGFloat width = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right - (self.coloumnsCount - 1) * self.columnMargin ) / self.coloumnsCount;
    CGFloat height = [self.delegate waterflowLayout:self heightForWidth:width atIndexPath:indexPath];
    
    // 计算位置
    CGFloat x = self.sectionInset.left + (width + self.columnMargin) * [minColum intValue];
    CGFloat y = self.rowMargin + [self.maxDict[minColum] floatValue];
    
    // 更新这一列最大的 Y 值
    self.maxDict[minColum] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, width, height);
    
    return attrs;
}

// 在指定范围内返回每一个 cell 的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrsArray;
}

#pragma mark - lazy
- (NSMutableDictionary *)maxDict
{
    if (!_maxDict ) {
        _maxDict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i < self.coloumnsCount; i ++) {
            NSString *column = [NSString stringWithFormat:@"%d",i];
            self.maxDict[column] = @0;
        }
    }
    // @"0" : @(0), @"1" : @(0) , @"2" : @(0) 这种格式来存储这一列最大的 Y 值
    return _maxDict;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray ) {
        _attrsArray = [[NSMutableArray alloc]init];
    }
    return _attrsArray;
}



@end
