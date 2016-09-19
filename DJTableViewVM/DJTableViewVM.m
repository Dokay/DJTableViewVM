//
//  DJComponentTableViewVM.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVM.h"
#import "DJTableViewVMCell.h"
#import "DJTableViewVM+UIScrollViewDelegate.h"
#import "DJTableViewVM+UITableViewDelegate.h"
#import "DJTableViewPrefetchManager.h"

@interface DJTableViewVM()

@property (nonatomic, strong) NSMutableDictionary *registeredClasses;
@property (nonatomic, strong) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableDictionary *resuableCalculateCells;
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, strong) DJTableViewPrefetchManager *prefetchManager;
@property (nonatomic, assign) BOOL bPreetchEnabled;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation DJTableViewVM
@synthesize tableView = _tableView;
@dynamic rowHeight,sectionHeaderHeight,sectionFooterHeight,estimatedRowHeight,estimatedSectionHeaderHeight,estimatedSectionFooterHeight,separatorInset,separatorColor,tableHeaderView,tableFooterView,backgroundView;

- (id)init
{
    NSAssert(NO, @"please use other init methods instead");
    return nil;
}

- (id)initWithTableView:(UITableView *)tableView delegate:(id<DJTableViewVMDelegate>)delegate
{
    self = [self initWithTableView:tableView];
    if (self){
        self.delegate = delegate;
    }
    return self;
}

- (id)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self){
        tableView.delegate = self;
        tableView.dataSource = self;
        self.tableView = tableView;

        self.mutableSections        = [[NSMutableArray alloc] init];
        self.registeredClasses      = [[NSMutableDictionary alloc] init];
        self.registeredXIBs         = [[NSMutableDictionary alloc] init];
        self.resuableCalculateCells = [[NSMutableDictionary alloc] init];
        
        [self registerDefaultCells];
    }
    return self;
}

#pragma mark - implement dictionary key value style
- (id)objectAtKeyedSubscript:(id <NSCopying>)key
{
    return [self.registeredClasses objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key
{
    [self registerRowClass:(NSString *)key forCellClass:obj];
}

#pragma mark  - regist class name
- (void)registerDefaultCells
{
    self[@"DJTableViewVMRow"] = @"DJTableViewVMCell";
}

- (void)registerRowClass:(NSString *)rowClass forCellClass:(NSString *)cellClass
{
    [self registerRowClass:rowClass forCellClass:cellClass bundle:nil];
}

- (void)registerRowClass:(NSString *)rowClass forCellClass:(NSString *)cellClass bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(rowClass), ([NSString stringWithFormat:@"Row class '%@' does not exist.", rowClass]));
    NSAssert(NSClassFromString(cellClass), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", cellClass]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(rowClass)] = NSClassFromString(cellClass);
    
    if (!bundle){
        bundle = [NSBundle mainBundle];
    }
    
    if ([bundle pathForResource:cellClass ofType:@"nib"]) {
        self.registeredXIBs[cellClass] = rowClass;
        [self.tableView registerNib:[UINib nibWithNibName:cellClass bundle:bundle] forCellReuseIdentifier:rowClass];
    }else{
        [self.tableView registerClass:NSClassFromString(cellClass) forCellReuseIdentifier:cellClass];
    }
}

- (Class)classForCellAtIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NSObject *row = [section.rows objectAtIndex:indexPath.row];
    return [self.registeredClasses objectForKey:row.class];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [self checkPrefetchEnabled];
    return self.mutableSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count > sectionIndex) {
        return ((DJTableViewVMSection *)[self.mutableSections objectAtIndex:sectionIndex]).rows.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell<DJTableViewVMCellDelegate> *cell = [self dj_tableView:tableView cellForRowAtIndexPath:indexPath forCalculateHeight:NO];
    
    if ([cell isKindOfClass:[DJTableViewVMCell class]] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded) {
        cell.tableViewVM = self;
        
        // DJTableViewVMDelegate
        if ([self.delegate conformsToProtocol:@protocol(DJTableViewVMDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willLoadCell:forRowAtIndexPath:)])
            [self.delegate tableView:tableView willLoadCell:cell forRowAtIndexPath:indexPath];
        
        if (!cell.loaded) {
            cell.loaded = YES;
            [cell cellDidLoad];
        }
        
        // DJTableViewVMDelegate
        if ([self.delegate conformsToProtocol:@protocol(DJTableViewVMDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didLoadCell:forRowAtIndexPath:)])
            [self.delegate tableView:tableView didLoadCell:cell forRowAtIndexPath:indexPath];
    }
    
    [cell cellWillAppear];
    
    NSAssert(cell, @"cell for cellForRowAtIndexPath: (section:%ld row:%ld) is null,make sure you have resisted it corectly.",indexPath.section,indexPath.row);
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    return section.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)sectionIndex
{
    if (self.mutableSections.count <= sectionIndex) {
        return nil;
    }
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:sectionIndex];
    return section.footerTitle;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    DJTableViewVMSection *sourceSection = [self.mutableSections objectAtIndex:sourceIndexPath.section];
    DJTableViewVMRow *rowVM = [sourceSection.rows objectAtIndex:sourceIndexPath.row];
    [sourceSection removeRowAtIndex:sourceIndexPath.row];
    
    DJTableViewVMSection *destinationSection = [self.mutableSections objectAtIndex:destinationIndexPath.section];
    [destinationSection insertRow:rowVM atIndex:destinationIndexPath.row];
    
    if (rowVM.moveCellCompletionHandler){
        rowVM.moveCellCompletionHandler(rowVM, sourceIndexPath, destinationIndexPath);
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mutableSections.count <= indexPath.section) {
        return NO;
    }
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [section.rows objectAtIndex:indexPath.row];
    return rowVM.moveCellHandler != nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < [self.mutableSections count]) {
        DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
        if (indexPath.row < [section.rows count]) {
            DJTableViewVMRow *rowVM = [section.rows objectAtIndex:indexPath.row];
            if ([rowVM isKindOfClass:[DJTableViewVMRow class]]) {
                return rowVM.editingStyle != UITableViewCellEditingStyleNone
                || rowVM.moveCellHandler
                || rowVM.editActions.count > 0;
            }
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMSection *sectionVM = [self.mutableSections objectAtIndex:indexPath.section];
    DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        void(^completeBlock)() = ^{
            [sectionVM removeRowAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            for (NSInteger i = indexPath.row; i < sectionVM.rows.count; i++) {
                DJTableViewVMRow *afterDeleteRowVM = [sectionVM.rows objectAtIndex:i];
                id<DJTableViewVMCellDelegate> cell = (id<DJTableViewVMCellDelegate>)[tableView cellForRowAtIndexPath:afterDeleteRowVM.indexPath];
                cell.rowIndex--;
            }
        };
        if (rowVM.deleteCellCompleteHandler) {
            rowVM.deleteCellCompleteHandler(rowVM,completeBlock);
        } else {
            if (rowVM.deleteCellHandler){
                rowVM.deleteCellHandler(rowVM);
                completeBlock();
            }
        }
    }else if (editingStyle == UITableViewCellEditingStyleInsert) {
        if (rowVM.insertCellHandler) {
            rowVM.insertCellHandler(rowVM);
        }
    }
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED
{
    if ([self.dataSource conformsToProtocol:@protocol(UITableViewDataSource)] && [self.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        [self.dataSource sectionIndexTitlesForTableView:tableView];
    }
    
    BOOL bIndexTitle = NO;
    for (DJTableViewVMSection *sectionVM in self.sections) {
        if (sectionVM.sectionIndexTitle.length > 0) {
            bIndexTitle = YES;
            break;
        }
    }
    if (bIndexTitle) {
        NSMutableArray *titlesArray = [NSMutableArray new];
        for (DJTableViewVMSection *sectionVM in self.sections) {
            if (sectionVM.sectionIndexTitle.length > 0) {
                [titlesArray addObject:sectionVM.sectionIndexTitle];
            }else{
                [titlesArray addObject:@""];
            }
        }
        return titlesArray;
    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED
{
    if ([self.dataSource conformsToProtocol:@protocol(UITableViewDataSource)] && [self.dataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        [self.dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    
    for (DJTableViewVMSection *sectionVM in self.sections) {
        if (sectionVM.sectionIndexTitle.length > 0
            && [sectionVM.sectionIndexTitle isEqualToString:title]) {
            return sectionVM.index;
        }
    }
    
    return index;
}

#pragma mark - DJTableViewDataSourcePrefetching
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
        DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
        if (rowVM.prefetchHander) {
            rowVM.prefetchHander(rowVM);
        }
    }
}

- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    for (NSIndexPath *indexPath in indexPaths) {
        DJTableViewVMSection *sectionVM = [self.sections objectAtIndex:indexPath.section];
        DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
        if (rowVM.prefetchCancelHander) {
            rowVM.prefetchCancelHander(rowVM);
        }
    }
}

#pragma mark - caculate height
- (UITableViewCell<DJTableViewVMCellDelegate> *)dj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath forCalculateHeight:(BOOL)forCaculateHeight
{
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    if ([row isKindOfClass:[DJTableViewVMRow class]])
    {
        cellStyle = ((DJTableViewVMRow *)row).style;
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"DJTableViewVMDefaultIdentifier_%@_%li", [row class], (long) cellStyle];
    
    Class cellClass = [self classForCellAtIndexPath:indexPath];
    
    if (self.registeredXIBs[NSStringFromClass(cellClass)]) {
        cellIdentifier = self.registeredXIBs[NSStringFromClass(cellClass)];
    }
    
    if ([row respondsToSelector:@selector(cellIdentifier)] && row.cellIdentifier) {
        cellIdentifier = row.cellIdentifier;
    }
    
    UITableViewCell<DJTableViewVMCellDelegate> *cell;
    if (forCaculateHeight == NO) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        }
    }else{
        //cell with dequeueReusableCellWithIdentifier: is not resuable.
        cell = [self.resuableCalculateCells objectForKey:cellIdentifier];
        if (cell == nil) {
            if (self.registeredXIBs[NSStringFromClass(cellClass)]) {
                cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(cellClass) owner:nil options:nil] lastObject];
            }else{
                cell = [[cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
            }
            [self.resuableCalculateCells setObject:cell forKey:cellIdentifier];
        }
    }
    
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentTableView = tableView;
    cell.section = section;
    cell.rowVM = row;
    
    return cell;
}

- (CGFloat)heightWithAutoLayoutCellWithIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if (row.heightCaculateType == DJCellHeightCaculateAutoFrameLayout
        || row.heightCaculateType == DJCellHeightCaculateAutoLayout) {
        UITableViewCell<DJTableViewVMCellDelegate> *templateLayoutCell = [self dj_tableView:self.tableView cellForRowAtIndexPath:indexPath forCalculateHeight:YES];
        
        // Manually calls to ensure consistent behavior with actual cells (that are displayed on screen).
        [templateLayoutCell prepareForReuse];
        
        // Customize and provide content for our template cell.
        if (templateLayoutCell) {
            if (!templateLayoutCell.loaded) {
                [templateLayoutCell cellDidLoad];
            }
            [templateLayoutCell cellWillAppear];
        }
        
        CGFloat contentViewWidth = CGRectGetWidth(self.tableView.frame);
        
        // If a cell has accessory view or system accessory type, its content view's width is smaller
        // than cell's by some fixed values.
        if (templateLayoutCell.accessoryView) {
            contentViewWidth -= 16 + CGRectGetWidth(templateLayoutCell.accessoryView.frame);
        } else {
            static const CGFloat systemAccessoryWidths[] = {
                [UITableViewCellAccessoryNone] = 0,
                [UITableViewCellAccessoryDisclosureIndicator] = 34,
                [UITableViewCellAccessoryDetailDisclosureButton] = 68,
                [UITableViewCellAccessoryCheckmark] = 40,
                [UITableViewCellAccessoryDetailButton] = 48
            };
            contentViewWidth -= systemAccessoryWidths[templateLayoutCell.accessoryType];
        }
        
        CGSize fittingSize = CGSizeZero;
        
        if (row.heightCaculateType == DJCellHeightCaculateAutoFrameLayout) {
            // If not using auto layout, you have to override "-sizeThatFits:" to provide a fitting size by yourself.
            // This is the same method used in iOS8 self-sizing cell's implementation.
            // Note: fitting height should not include separator view.
            SEL selector = @selector(sizeThatFits:);
            BOOL inherited = ![templateLayoutCell isMemberOfClass:UITableViewCell.class];
            BOOL overrided = [templateLayoutCell.class instanceMethodForSelector:selector] != [UITableViewCell instanceMethodForSelector:selector];
            if (!inherited || !overrided) {
                NSAssert(NO, @"Customized cell must override '-sizeThatFits:' method if not using auto layout.");
            }
            fittingSize = [templateLayoutCell sizeThatFits:CGSizeMake(contentViewWidth, 0)];
        } else {
            // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
            // of growing horizontally, in a flow-layout manner.
            if (contentViewWidth > 0) {
                NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:templateLayoutCell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
                [templateLayoutCell.contentView addConstraint:widthFenceConstraint];
                // Auto layout engine does its math
                fittingSize = [templateLayoutCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
                [templateLayoutCell.contentView removeConstraint:widthFenceConstraint];
                
            }
        }
        
        // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
        if (self.tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
            fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
        }
        return fittingSize.height;
    }else{
        NSAssert(FALSE, @"heightCaculateType is no ,please set it yes and implement cell height auto");
        return 0;
    }
}

- (void)checkPrefetchEnabled
{
    for (DJTableViewVMSection *sectionVM in self.sections) {
        for (DJTableViewVMRow *rowVM in sectionVM.rows) {
            if (rowVM.prefetchHander || rowVM.prefetchCancelHander) {
                self.bPreetchEnabled = YES;
                return;
            }
        }
    }
    self.bPreetchEnabled = NO;
}

#pragma mark - sections manage
- (NSArray *)sections
{
    return self.mutableSections;
}

- (void)addSection:(DJTableViewVMSection *)section
{
    section.tableViewVM = self;
    [self.mutableSections addObject:section];
}

- (void)addSectionsFromArray:(NSArray *)array
{
    for (DJTableViewVMSection *section in array){
        section.tableViewVM = self;
    }
    [self.mutableSections addObjectsFromArray:array];
}

- (void)insertSection:(DJTableViewVMSection *)section atIndex:(NSUInteger)index
{
    section.tableViewVM = self;
    [self.mutableSections insertObject:section atIndex:index];
}

- (void)removeSection:(DJTableViewVMSection *)section
{
    [self.mutableSections removeObject:section];
}

- (void)removeAllSections
{
    [self.mutableSections removeAllObjects];
}

- (void)removeSectionsInArray:(NSArray *)otherArray
{
    [self.mutableSections removeObjectsInArray:otherArray];
}

- (void)removeSectionAtIndex:(NSUInteger)index
{
    [self.mutableSections removeObjectAtIndex:index];
}

#pragma mark - setter
- (void)setBPreetchEnabled:(BOOL)bPreetchEnabled
{
    _bPreetchEnabled = bPreetchEnabled;
    
    if ([self.tableView respondsToSelector:@selector(setPrefetchDataSource:)]) {
        if (bPreetchEnabled) {
            [self.tableView performSelector:@selector(setPrefetchDataSource:) withObject:self];
        }else{
            [self.tableView performSelector:@selector(setPrefetchDataSource:) withObject:nil];
        }
    }else{
        self.prefetchManager.bPreetchEnabled = bPreetchEnabled;
    }
}

#pragma mark - getter
- (DJTableViewPrefetchManager *)prefetchManager
{
    if (_prefetchManager == nil) {
        _prefetchManager = [[DJTableViewPrefetchManager alloc] initWithScrollView:self.tableView];
        __weak DJTableViewVM *weakSelf = self;
        [_prefetchManager setPrefetchCompletion:^(NSArray *addedArray, NSArray *cancelArray) {
            for (NSIndexPath *indexPath in addedArray) {
                DJTableViewVMSection *sectionVM = [weakSelf.sections objectAtIndex:indexPath.section];
                DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
                if (rowVM.prefetchHander) {
                    rowVM.prefetchHander(rowVM);
                }
            }
            
            for (NSIndexPath *indexPath in cancelArray) {
                DJTableViewVMSection *sectionVM = [weakSelf.sections objectAtIndex:indexPath.section];
                DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
                if (rowVM.prefetchCancelHander) {
                    rowVM.prefetchCancelHander(rowVM);
                }
            }
        }];
    }
    return _prefetchManager;
}

@end
