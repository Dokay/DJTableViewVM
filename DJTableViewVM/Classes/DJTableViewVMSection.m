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

#define kDefaultWidth 100 

@interface DJTableViewVMSection()

@property (nonatomic, strong) NSMutableArray *mutableRows;
@property (nonatomic, strong) NSMutableDictionary *automaticHeightCache;

@end

@implementation DJTableViewVMSection

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle
{
    return [[self alloc ] initWithHeaderTitle:headerTitle];
}

+ (instancetype)sectionWithFooterTitle:(NSString *)footerTitle
{
    return [[self alloc ] initWithFooterTitle:footerTitle];
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

+ (instancetype)sectionWithHeaderHeight:(CGFloat)hheight andFooterHeight:(CGFloat)fheight
{
    UIView *headerView = nil;
    if (hheight > 0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultWidth, hheight)];
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    UIView *footerView = nil;
    if (fheight > 0) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultWidth, fheight)];
        [footerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithHeaderView:headerView footerView:footerView];
}

+ (instancetype)sectionWithHeaderHeight:(CGFloat)hheight
{
    UIView *headerView = nil;
    if (hheight > 0) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultWidth, hheight)];
        [headerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithHeaderView:headerView];
}

+ (instancetype)sectionWithFooterHeight:(CGFloat)fheight
{
    UIView *footerView = nil;
    if (fheight > 0) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultWidth, fheight)];
        [footerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithFooterView:footerView];
}

- (id)initWithHeaderTitle:(NSString *)headerTitle
{
    return [self initWithHeaderTitle:headerTitle footerTitle:nil];
}

- (id)initWithFooterTitle:(NSString *)footerTitle
{
    return [self initWithHeaderTitle:nil footerTitle:footerTitle];
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

- (id)initWithFooterView:(UIView *)footerView
{
    return [self initWithHeaderView:nil footerView:footerView];
}

- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView
{
    self = [self init];
    if (self){
        self.headerView = headerView;
        self.footerView = footerView;
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        _headerHeightCaculateType = DJSectionHeightCaculateTypeDefault;
        _footerHeightCaculateType = DJSectionHeightCaculateTypeDefault;
    }
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
        ((DJTableViewVMRow *)row).sectionVM = self;
    }
    
    [self.mutableRows addObject:row];
}

- (void)addRowsFromArray:(NSArray *)array
{
    for (DJTableViewVMRow *Row in array)
    {
        if ([Row isKindOfClass:[DJTableViewVMRow class]]){
            ((DJTableViewVMRow *)Row).sectionVM = self;
        }
    }
    
    [self.mutableRows addObjectsFromArray:array];
}

- (void)insertRow:(id)row atIndex:(NSUInteger)index
{
    if ([row isKindOfClass:[DJTableViewVMRow class]]){
        ((DJTableViewVMRow *)row).sectionVM = self;
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
    if (_mutableRows == nil) {
        _mutableRows = [NSMutableArray new];
    }
    return _mutableRows;
}

- (NSMutableDictionary *)automaticHeightCache
{
    if (_automaticHeightCache == nil) {
        _automaticHeightCache = [NSMutableDictionary new];
    }
    return _automaticHeightCache;
}

@end
