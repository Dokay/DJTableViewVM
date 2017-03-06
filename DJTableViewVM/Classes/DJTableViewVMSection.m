//
//  DJComponentTableViewVMSection.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMSection.h"
#import "DJTableViewVMRow.h"
#import "DJTableViewVM.h"

@interface DJTableViewVMSection()

@property (strong, nonatomic) NSMutableArray *mutableRows;

@end

@implementation DJTableViewVMSection

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle
{
    return [[self alloc ] initWithHeaderTitle:headerTitle];
}

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    return [[self alloc] initWithHeaderTitle:headerTitle footerTitle:footerTitle];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithFooterView:(UIView *)footerView
{
    return [[self alloc] initWithHeaderView:nil footerView:footerView];
}

+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    return [[self alloc] initWithHeaderView:headerView footerView:footerView];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle
{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

+ (instancetype)sectionWithHeaderHeight:(CGFloat)hheight andFooterHeight:(CGFloat)fheight
{
    UIView *headerView = nil;
    if (hheight > 0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, hheight)];
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    UIView *footerView = nil;
    if (fheight > 0) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, fheight)];
        [footerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithHeaderView:headerView footerView:footerView];
}

+ (instancetype)sectionWithHeaderHeight:(CGFloat)hheight
{
    UIView *headerView = nil;
    if (hheight > 0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, hheight)];
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithHeaderView:headerView];
}

+ (instancetype)sectionWithFooterHeight:(CGFloat)fheight
{
    UIView *footerView = nil;
    if (fheight > 0) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, fheight)];
        [footerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithFooterView:footerView];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle
{
    self = [self init];
    if (!self)
        return nil;
    
    self.headerTitle = headerTitle;
    self.footerTitle = footerTitle;
    
    return self;
}

- (id)initWithHeaderView:(UIView *)headerView
{
    return [self initWithHeaderView:headerView footerView:nil];
}

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    self = [self init];
    if (!self)
        return nil;
    
    self.headerView = headerView;
    self.footerView = footerView;
    
    return self;
}

- (NSUInteger)index
{
    DJTableViewVM *tableViewVM = self.tableViewVM;
    return [tableViewVM.sections indexOfObject:self];
}

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewVM.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
}

#pragma mark - rows manage
- (NSArray *)rows
{
    return self.mutableRows;
}

- (void)addRow:(id)row
{
    if ([row isKindOfClass:[DJTableViewVMRow class]]){
        ((DJTableViewVMRow *)row).section = self;
    }
    
    [self.mutableRows addObject:row];
}

- (void)addRowsFromArray:(NSArray *)array
{
    for (DJTableViewVMRow *Row in array)
    {
        if ([Row isKindOfClass:[DJTableViewVMRow class]]){
            ((DJTableViewVMRow *)Row).section = self;
        }
    }
    
    [self.mutableRows addObjectsFromArray:array];
}

- (void)insertRow:(id)row atIndex:(NSUInteger)index
{
    if ([row isKindOfClass:[DJTableViewVMRow class]]){
        ((DJTableViewVMRow *)row).section = self;
    }
    
    [self.mutableRows insertObject:row atIndex:index];
}

- (void)removeRowAtIndex:(NSUInteger)index
{
    [self.mutableRows removeObjectAtIndex:index];
}

- (void)removeRow:(id)row
{
    [self.mutableRows removeObject:row];
}

- (void)removeAllRows
{
    [self.mutableRows removeAllObjects];
}

#pragma mark - getter
- (NSMutableArray *)mutableRows
{
    if (!_mutableRows) {
        _mutableRows = [NSMutableArray new];
    }
    return _mutableRows;
}

@end
