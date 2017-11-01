//
//  DJComponentTableViewVM+UIScrollViewDelegate.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVM+UIScrollViewDelegate.h"
#import "DJTableViewVM+Keyboard.h"

@implementation DJTableViewVM(UIScrollViewDelegate)

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]){
        [self.delegate scrollViewDidScroll:self.tableView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidZoom:)]){
        [self.delegate scrollViewDidZoom:self.tableView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]){
        [self.delegate scrollViewWillBeginDragging:self.tableView];
    }
    [self scrollHideKeyboard];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]){
        [self.delegate scrollViewWillEndDragging:self.tableView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]){
        [self.delegate scrollViewDidEndDragging:self.tableView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]){
        [self.delegate scrollViewWillBeginDecelerating:self.tableView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]){
        [self.delegate scrollViewDidEndDecelerating:self.tableView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]){
        [self.delegate scrollViewDidEndScrollingAnimation:self.tableView];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]){
        return [self.delegate viewForZoomingInScrollView:self.tableView];
    }
    
    return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]){
        [self.delegate scrollViewWillBeginZooming:self.tableView withView:view];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]){
        [self.delegate scrollViewDidEndZooming:self.tableView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]){
        return [self.delegate scrollViewShouldScrollToTop:self.tableView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]){
        [self.delegate scrollViewDidScrollToTop:self.tableView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView
{
    if ([self.delegate conformsToProtocol:@protocol(UIScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]){
        [self.delegate performSelector:@selector(scrollViewDidChangeAdjustedContentInset:) withObject:self.tableView];
    }
}

@end
