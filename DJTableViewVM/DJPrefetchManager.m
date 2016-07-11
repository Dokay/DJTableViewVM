//
//  DJPrefetchManager.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/7/7.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJPrefetchManager.h"

typedef NS_ENUM(NSInteger,DJPrefetchScrollDirection) {
    DJPrefetchScrollDirectionVertical,
    DJPrefetchScrollDirectionHorizontal
};

@interface DJPrefetchManager()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *lastestPrefetchedindexPaths;
@property (nonatomic, assign) CGFloat prefetchRectSizeRatio;
@property (nonatomic, assign) CGFloat updateSizeRatio;
@property (nonatomic, assign) CGPoint lastPrefetchedOffset;

@end

@implementation DJPrefetchManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super init];
    if (self) {
        self.scrollView = scrollView;
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        _bPreetchEnabled = NO;
        _prefetchRectSizeRatio = 1.0f;//next screen
        _updateSizeRatio = 0.1;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSAssert(NO, @"Please use initWithScrollView: instead");
    }
    return self;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
}

- (void)setPreetchEnabled:(BOOL)bPreetchEnabled
{
    _bPreetchEnabled = bPreetchEnabled;
    if (_bPreetchEnabled) {
        [self checkPrefetching];
    }else{
        _lastPrefetchedOffset = CGPointZero;
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.scrollView) {
        if (self.bPreetchEnabled) {
            [self checkPrefetching];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - private methods
- (void)checkPrefetching
{
    if ([self needCheckContentChangedForPrefetching]) {
        BOOL isScrollingForward = [self isScrollingForwardlastPrefetchedOffset:self.lastPrefetchedOffset];
        CGRect prefetchRect = [self PrefetchRectWithIsScrollingForward:isScrollingForward sizeRatio:self.prefetchRectSizeRatio];
        NSArray *indexPathsPrefetch = [self indexPathsInRect:prefetchRect];
        NSArray *indexPathsVisible = [self indexPathsForVisibleRows];
        
        NSMutableArray *willPrefetchIndexPaths = [NSMutableArray new];
        for (NSIndexPath *indexPathPrefetch in indexPathsPrefetch) {
            BOOL contains = NO;
            for (NSIndexPath *indexPathVisible in indexPathsVisible) {
                if (indexPathVisible.section == indexPathPrefetch.section && indexPathVisible.item == indexPathPrefetch.item) {
                    contains = YES;
                    break;
                }
            }
            if (!contains) {
                [willPrefetchIndexPaths addObject:indexPathPrefetch];
            }
        }
        
        [willPrefetchIndexPaths sortUsingComparator:^NSComparisonResult(NSIndexPath *  _Nonnull obj1, NSIndexPath *  _Nonnull obj2) {
            if (isScrollingForward) {
                if (obj1.section < obj2.section || obj1.item < obj2.item) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }else{
                if (obj1.section > obj2.section || obj1.item > obj2.item) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }
        }];
        
        [self updateIndexPaths:willPrefetchIndexPaths];
        
        self.lastPrefetchedOffset = self.scrollView.contentOffset;
    }
}

- (void)updateIndexPaths:(NSArray *)willPrefetchIndexPaths
{
    NSMutableArray *toBeAddedArray = [NSMutableArray new];
    NSMutableArray *toBeRemovedArray = [NSMutableArray new];
    
    for (NSIndexPath *indexPathNew in willPrefetchIndexPaths) {
        BOOL contains = NO;
        for (NSIndexPath *indexPath in self.lastestPrefetchedindexPaths) {
            if (indexPathNew.section == indexPath.section && indexPathNew.item == indexPath.item) {
                contains = YES;
                break;
            }
        }
        if (!contains) {
            [toBeAddedArray addObject:indexPathNew];
        }
    }
    
    for (NSIndexPath *indexPath in self.lastestPrefetchedindexPaths) {
        BOOL contains = NO;
        for (NSIndexPath *indexPathNew in willPrefetchIndexPaths) {
            if (indexPathNew.section == indexPath.section && indexPathNew.item == indexPath.item) {
                contains = YES;
                break;
            }
        }
        if (!contains) {
            [toBeRemovedArray addObject:indexPath];
        }
    }
//    NSMutableArray *newIndexArray = [NSMutableArray arrayWithArray:willPrefetchIndexPaths];
    //    if (newIndexArray.count > 3) {
    //        //latest 3 items will not be canceled
    //        [newIndexArray removeObjectsInRange:NSMakeRange(0, 3)];
    //    }
    self.lastestPrefetchedindexPaths = willPrefetchIndexPaths;
    if (self.prefetchCompletion) {
        self.prefetchCompletion(toBeAddedArray,toBeRemovedArray);
    }
}

/**
 *  check the distance with last Prefetched offset to detemine whether new offset from KVO should be updated
 *
 *  @return
 */
- (BOOL)needCheckContentChangedForPrefetching
{
    if (self.lastPrefetchedOffset.x && self.lastPrefetchedOffset.y == 0) {
        return YES;
    }
    
    CGFloat minThreshold = (self.scrollDirection ==  DJPrefetchScrollDirectionVertical ? CGRectGetHeight : CGRectGetWidth)(self.scrollView.bounds) * self.updateSizeRatio;
    CGFloat scrolledDistance = [self distanceBetweenPoint:self.scrollView.contentOffset andPoint:self.lastPrefetchedOffset];
    return scrolledDistance > minThreshold;
}

- (CGFloat)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2
{
    CGFloat dx = p2.x - p1.x, dy = p2.y - p1.y;
    return sqrt((dx * dx) + (dy * dy));
}

- (CGRect)PrefetchRectWithIsScrollingForward:(BOOL)isScrollingForward sizeRatio:(CGFloat)sizeRatio
{
    CGRect visualRect = CGRectMake(self.scrollView.contentOffset.x, self.scrollView.contentOffset.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    switch ([self scrollDirection]) {
        case DJPrefetchScrollDirectionVertical:
        {
            CGFloat height = CGRectGetHeight(visualRect) * sizeRatio;
            CGFloat y = isScrollingForward ? CGRectGetMaxY(visualRect) : CGRectGetMinY(visualRect) - height;
            return CGRectIntegral(CGRectMake(0, y, CGRectGetWidth(visualRect),height));
        }
            break;
        case DJPrefetchScrollDirectionHorizontal:
        {
            CGFloat width = CGRectGetWidth(visualRect) * sizeRatio;
            CGFloat x = isScrollingForward ? CGRectGetMaxX(visualRect) : CGRectGetMinX(visualRect) - width;
            return CGRectIntegral(CGRectMake(x, 0, width, CGRectGetHeight(visualRect)));
        }
            break;
        default:
            break;
    }
    return CGRectZero;
}

- (BOOL)isScrollingForwardlastPrefetchedOffset:(CGPoint)lastPrefetchedOffset
{
    switch (self.scrollDirection) {
        case DJPrefetchScrollDirectionVertical:
        {
            return self.scrollView.contentOffset.y >= lastPrefetchedOffset.y;
        }
            break;
        case DJPrefetchScrollDirectionHorizontal:
        {
            return self.scrollView.contentOffset.x >= lastPrefetchedOffset.x;
        }
            break;
        default:
            break;
    }
}

- (DJPrefetchScrollDirection)scrollDirection
{
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        return DJPrefetchScrollDirectionVertical;
    }else{
        UICollectionView *collectionView = (UICollectionView *)self.scrollView;
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)collectionView.collectionViewLayout;
        if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
            if (layout.scrollDirection == UICollectionViewScrollDirectionVertical) {
                return DJPrefetchScrollDirectionVertical;
            }else{
                return DJPrefetchScrollDirectionHorizontal;
            }
        }else{
            NSAssert(NO, @"layout must be UICollectionViewFlowLayout");
            return DJPrefetchScrollDirectionVertical;
        }
    }
}

- (NSArray *)indexPathsInRect:(CGRect)rect
{
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        return [(UITableView *)self.scrollView indexPathsForRowsInRect:rect];
    }else{
        NSMutableArray *attributeIndexPaths = [NSMutableArray new];
        NSArray *attributesArray = [((UICollectionView *)self.scrollView).collectionViewLayout layoutAttributesForElementsInRect:rect];
        for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
            if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
                [attributeIndexPaths addObject:attributes.indexPath];
            }
        }
        return attributeIndexPaths.copy;
    }
}

- (NSArray *)indexPathsForVisibleRows
{
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        return [(UITableView *)self.scrollView indexPathsForVisibleRows];
    }else{
        return [(UICollectionView *)self.scrollView indexPathsForVisibleItems];
    }
}


@end
