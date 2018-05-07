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
@property (nonatomic, assign) DJSectionHeightCaculateType headerHeightCaculateType;
@property (nonatomic, assign) DJSectionHeightCaculateType footerHeightCaculateType;

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
    return [[self class] sectionWithHeaderView:headerView footerView:nil];
}

+ (instancetype)sectionWithFooterHeight:(CGFloat)fheight
{
    UIView *footerView = nil;
    if (fheight > 0) {
        footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDefaultWidth, fheight)];
        [footerView setBackgroundColor:[UIColor clearColor]];
    }
    return [[self class] sectionWithHeaderView:nil footerView:footerView];
}

+ (instancetype)sectionWithHeaderAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets
{
    return [[self alloc] initWithHeaderAttributedText:attributedString edgeInsets:edgeInsets];
}

+ (instancetype)sectionWithFooterAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets
{
    return [[self alloc] initWithFooterAttributedText:attributedString edgeInsets:edgeInsets];
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

- (id)initWithHeaderAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets
{
    UIView *headerView = [DJTableViewVMSection holderViewWithAttributedText:attributedString edgeInsets:edgeInsets];
    self = [self initWithHeaderView:headerView];
    if (self) {
        self.headerHeightCaculateType = DJSectionHeightCaculateTypeAutomatic;
    }
    return self;
}

- (id)initWithFooterAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets
{
    UIView *footerView = [DJTableViewVMSection holderViewWithAttributedText:attributedString edgeInsets:edgeInsets];
    self = [self initWithFooterView:footerView];
    if (self) {
        self.footerHeightCaculateType = DJSectionHeightCaculateTypeAutomatic;
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

+ (UIView *)holderViewWithAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets
{
    NSAssert(attributedString, @"attributedString can not be nil");
    UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 28)];//28 is estimated hight
    holderView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.attributedText = attributedString;
    titleLabel.numberOfLines = 0;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [holderView addSubview:titleLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(holderView,titleLabel);
    NSDictionary *metrics = @{@"top":@(edgeInsets.top),
                              @"bottom":@(edgeInsets.bottom),
                              @"left":@(edgeInsets.left),
                              @"right":@(edgeInsets.right)};
    [holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[titleLabel]-(bottom)-|" options:0 metrics:metrics views:views]];
    [holderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[titleLabel]-(right)-|" options:0 metrics:metrics views:views]];
    
    return holderView;
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

- (void)sortRowsUsingComparator:(NSComparator NS_NOESCAPE)cmptr
{
    [self.mutableRows sortUsingComparator:cmptr];
}

- (void)sortRowsWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr
{
    [self.mutableRows sortWithOptions:opts usingComparator:cmptr];
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

#pragma mark - manage rows with animation
- (void)addRow:(id)row withRowAnimation:(UITableViewRowAnimation)animation
{
    if (!row) {
        return;
    }
    
    [self addRow:row];
    
    [self.tableViewVM.tableView insertRowsAtIndexPaths:@[[row indexPath]] withRowAnimation:animation];
}

- (void)addRowsFromArray:(NSArray *)array withRowAnimation:(UITableViewRowAnimation)animation
{
    if (array.count == 0) {
        return;
    }
    
    [self addRowsFromArray:array];
    
    NSMutableArray *indexPaths = [array mutableArrayValueForKey:@"indexPath"];
    [self.tableViewVM.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)insertRow:(id)row atIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation
{
    if (!row || index > self.rows.count) {
        return;
    }
    
    [self insertRow:row atIndex:index];
    
    [self.tableViewVM.tableView insertRowsAtIndexPaths:@[[row indexPath]] withRowAnimation:animation];
}

- (void)removeRow:(id)row withRowAnimation:(UITableViewRowAnimation)animation
{
    if (!row) {
        return;
    }
    
    NSIndexPath *destIndexPath = [row indexPath];
    [self removeRow:row];
    
    [self.tableViewVM.tableView deleteRowsAtIndexPaths:@[destIndexPath] withRowAnimation:animation];
}

- (void)removeRowAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation
{
    if (index >= self.rows.count) {
        return;
    }
    
    [self removeRowAtIndex:index];
    
    [self.tableViewVM.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:self.index]] withRowAnimation:animation];
}

- (void)removeAllRowsWithRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexPathArray = [NSMutableArray new];
    for(NSInteger i = 0; i < self.rows.count; i++){
        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:self.index]];
    }
    
    [self removeAllRows];
    
    [self.tableViewVM.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:animation];
}

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation
{
    [self.tableViewVM.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.index] withRowAnimation:animation];
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
