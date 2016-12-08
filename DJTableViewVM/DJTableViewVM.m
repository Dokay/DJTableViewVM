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
#import "DJLazyTaskManager.h"
#import "DJLog.h"

@interface DJTableViewVM()

@property (nonatomic, strong) NSMutableDictionary *registeredClasses;
@property (nonatomic, strong) NSMutableDictionary *registeredXIBs;
@property (nonatomic, strong) NSMutableDictionary *resuableCalculateCells;
@property (nonatomic, strong) NSMutableArray *mutableSections;

@property (nonatomic, strong) DJTableViewPrefetchManager *prefetchManager;
@property (nonatomic, strong) DJLazyTaskManager *lazyTaskManager;

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
        
        self.lazyTaskManager = [[DJLazyTaskManager alloc] init];
        
        [self p_registerDefaultCells];
    }
    return self;
}

- (void)dealloc
{
    [DJLog dj_debugLog:[NSString stringWithFormat:@"%@ dealloc",[self class]]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    UITableViewCell<DJTableViewVMCellDelegate> *cell = [self p_tableView:tableView cellForRowAtIndexPath:indexPath forCalculateHeight:NO];
    
    if ([cell isKindOfClass:[DJTableViewVMCell class]] && [cell respondsToSelector:@selector(loaded)] && !cell.loaded) {
        cell.tableViewVM = self;
        
        if (!cell.loaded) {
            if ([self.delegate conformsToProtocol:@protocol(DJTableViewVMDelegate)] && [self.delegate respondsToSelector:@selector(tableView:cellWillLoad:forRowAtIndexPath:)]){
                [self.delegate tableView:tableView cellWillLoad:cell forRowAtIndexPath:indexPath];
            }
            
            [cell cellDidLoad];
            
            if ([self.delegate conformsToProtocol:@protocol(DJTableViewVMDelegate)] && [self.delegate respondsToSelector:@selector(tableView:cellDidLoad:forRowAtIndexPath:)]){
                [self.delegate tableView:tableView cellDidLoad:cell forRowAtIndexPath:indexPath];
            }
        }
    }
    
    if ([self.delegate conformsToProtocol:@protocol(DJTableViewVMDelegate)] && [self.delegate respondsToSelector:@selector(tableView:cellWillAppear:forRowAtIndexPath:)]){
        [self.delegate tableView:tableView cellWillAppear:cell forRowAtIndexPath:indexPath];
    }
    
    [cell cellWillAppear];
    
    if ([self.delegate conformsToProtocol:@protocol(DJTableViewVMDelegate)] && [self.delegate respondsToSelector:@selector(tableView:cellDidAppear:forRowAtIndexPath:)]){
        [self.delegate tableView:tableView cellDidAppear:cell forRowAtIndexPath:indexPath];
    }
    
    if (self.preCaculateHeightEnable) {
        if (self.lazyTaskManager.state == DJLazyTaskManagerStateDefault) {
            [self p_startPreCaculateHeight];
        }
    }
    
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

#pragma mark - public methods
- (CGFloat)heightWithAutoLayoutCellForIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if (row.heightCaculateType == DJCellHeightCaculateAutoFrameLayout
        || row.heightCaculateType == DJCellHeightCaculateAutoLayout) {
        UITableViewCell<DJTableViewVMCellDelegate> *templateLayoutCell = [self p_tableView:self.tableView cellForRowAtIndexPath:indexPath forCalculateHeight:YES];
        
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

- (void)reloadData
{
    [self.tableView reloadData];
    
    if (self.preCaculateHeightEnable) {
        [self p_startPreCaculateHeight];
    }
}

#pragma mark - implement dictionary key value style
- (id)objectAtKeyedSubscript:(id<NSCopying>)key
{
    return [self.registeredClasses objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    [self p_registerRowClass:key forCellClass:obj];
}

#pragma mark  - regist class name
- (void)p_registerDefaultCells
{
    self[@"DJTableViewVMRow"] = @"DJTableViewVMCell";
}

- (void)p_registerRowClass:(id)rowClass forCellClass:(id)cellClass
{
    [self p_registerRowClass:rowClass forCellClass:cellClass bundle:nil];
}

- (void)p_registerRowClass:(id)rowClass forCellClass:(id)cellClass bundle:(NSBundle *)bundle
{
    Class _rowClass = [rowClass isKindOfClass:[NSString class]] ? NSClassFromString(rowClass) : rowClass;
    Class _cellClass = [cellClass isKindOfClass:[NSString class]] ? NSClassFromString(cellClass) : cellClass;
    
    NSAssert(_rowClass, ([NSString stringWithFormat:@"Row class '%@' does not exist.", rowClass]));
    NSAssert(_cellClass, ([NSString stringWithFormat:@"Cell class '%@' does not exist.", cellClass]));
    
    NSString *rowClassString = NSStringFromClass(_rowClass);
    NSString *cellClassString = NSStringFromClass(_cellClass);
    
    self.registeredClasses[rowClassString] = cellClassString;
    
    if (!bundle){
        bundle = [NSBundle mainBundle];
    }
    
    if ([bundle pathForResource:cellClassString ofType:@"nib"]) {
        self.registeredXIBs[cellClassString] = rowClassString;
        [self.tableView registerNib:[UINib nibWithNibName:cellClassString bundle:bundle] forCellReuseIdentifier:rowClassString];
    }else{
        [self.tableView registerClass:_cellClass forCellReuseIdentifier:rowClassString];
    }
}

- (NSString *)p_classNameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    NSObject *row = [section.rows objectAtIndex:indexPath.row];
    return [self.registeredClasses objectForKey:NSStringFromClass(row.class)];
}

- (UITableViewCell<DJTableViewVMCellDelegate> *)p_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath forCalculateHeight:(BOOL)forCaculateHeight
{
    DJTableViewVMSection *section = [self.mutableSections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    
    UITableViewCellStyle cellStyle = UITableViewCellStyleDefault;
    if ([row isKindOfClass:[DJTableViewVMRow class]])
    {
        cellStyle = ((DJTableViewVMRow *)row).style;
    }
    NSString *cellIdentifier = [NSString stringWithFormat:@"DJTableViewVMDefaultIdentifier_%@_%li", [row class], (long) cellStyle];
    NSString *cellClassName = [self p_classNameForCellAtIndexPath:indexPath];
    
    if (self.registeredXIBs[cellClassName]) {
        cellIdentifier = self.registeredXIBs[cellClassName];
    }
    
    if ([row respondsToSelector:@selector(cellIdentifier)] && row.cellIdentifier) {
        cellIdentifier = row.cellIdentifier;
    }
    
    UITableViewCell<DJTableViewVMCellDelegate> *cell;
    if (forCaculateHeight == NO) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
        }
    }else{
        //cell with dequeueReusableCellWithIdentifier: is not resuable.
        cell = [self.resuableCalculateCells objectForKey:cellIdentifier];
        if (cell == nil) {
            if (self.registeredXIBs[cellClassName]) {
                cell = [[[NSBundle mainBundle] loadNibNamed:cellClassName owner:nil options:nil] lastObject];
            }else{
                cell = [[NSClassFromString(cellClassName) alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
            }
            [self.resuableCalculateCells setObject:cell forKey:cellIdentifier];
        }
    }
    
    cell.rowIndex = indexPath.row;
    cell.sectionIndex = indexPath.section;
    cell.parentTableView = tableView;
    cell.section = section;
    cell.rowVM = row;
    
    if (cell == nil) {
        NSString *crashReason = [NSString stringWithFormat:@"cellForRowAtIndexPath: (section:%@ row:%@) returns nil,make sure you have resisted %@ corectly.",@(indexPath.section),@(indexPath.row),row.class];
        @throw([NSException exceptionWithName: @"DJTableViewVM Exception" reason:crashReason userInfo:nil]);
    }
    
    return cell;
}

#pragma mark - cell height preCache
- (void)p_startPreCaculateHeight
{
    if (!self.preCaculateHeightEnable) {
        return;
    }
    
    [self.lazyTaskManager stop];
    
    [self.sections enumerateObjectsUsingBlock:^(DJTableViewVMSection *  _Nonnull sectionVM, NSUInteger section_idx, BOOL * _Nonnull section_stop) {
        [sectionVM.rows enumerateObjectsUsingBlock:^(DJTableViewVMRow *  _Nonnull rowVM, NSUInteger row_idx, BOOL * _Nonnull row_stop) {
            if (rowVM.cellHeight == 0 && rowVM.heightCaculateType != DJCellHeightCaculateDefault) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row_idx inSection:section_idx];
                [self.lazyTaskManager addLazyTarget:self selector:@selector(p_preLoadForIndexPath:) param:indexPath];
            }
        }];
    }];
    
    [self.lazyTaskManager start];
}

- (void)p_preLoadForIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    if (section.rows.count > indexPath.row) {
        DJTableViewVMRow *rowVM = [section.rows objectAtIndex:indexPath.row];
        //maybe has caculated in normal scrolling
        if (rowVM.cellHeight == 0 && rowVM.heightCaculateType != DJCellHeightCaculateDefault) {
            rowVM.cellHeight = [self heightWithAutoLayoutCellForIndexPath:indexPath];
            [DJLog dj_debugLog:[NSString stringWithFormat:@"CellHeight:%f,indexPath:%@",rowVM.cellHeight,indexPath]];
        }else{
            [DJLog dj_debugLog:@"no need caculate"];
        }
    }
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
- (void)setPrefetchingEnabled:(BOOL)prefetchingEnabled
{
    _prefetchingEnabled = prefetchingEnabled;
    if ([self.tableView respondsToSelector:@selector(setPrefetchDataSource:)]) {
        if (prefetchingEnabled) {
            [self.tableView performSelector:@selector(setPrefetchDataSource:) withObject:self];
        }else{
            [self.tableView performSelector:@selector(setPrefetchDataSource:) withObject:nil];
        }
    }else{
        self.prefetchManager.bPreetchEnabled = prefetchingEnabled;
    }
}

- (void)setHeightPreCaculateEnable:(BOOL)heightPreCaculateEnable
{
    _preCaculateHeightEnable = heightPreCaculateEnable;
    if (_preCaculateHeightEnable) {
        [self p_startPreCaculateHeight];
    }else{
        [self.lazyTaskManager stop];
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
