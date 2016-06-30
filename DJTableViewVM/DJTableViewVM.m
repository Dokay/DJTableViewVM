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

@interface DJTableViewVM()

@property (strong, nonatomic) NSMutableDictionary *registeredXIBs;
@property (strong, nonatomic) NSMutableArray *mutableSections;


@end

@implementation DJTableViewVM

- (id)init
{
    NSAssert(NO, @"please use other init method instead");
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
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
    //TODO:implement prefetch under ios 10
#else
     tableView.prefetchDataSource = self;
#endif
        
        self.tableView = tableView;
        
        self.mutableSections   = [[NSMutableArray alloc] init];
        self.registeredClasses = [[NSMutableDictionary alloc] init];
        self.registeredXIBs    = [[NSMutableDictionary alloc] init];
        
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
    [self registerClass:(NSString *)key forCellWithReuseIdentifier:obj];
}

#pragma mark  - regist class name
- (void)registerDefaultCells
{
    self[@"DJTableViewVMRow"] = @"DJTableViewVMCell";
}

- (void)registerClass:(NSString *)rowClass forCellWithReuseIdentifier:(NSString *)identifier
{
    [self registerClass:rowClass forCellWithReuseIdentifier:identifier bundle:nil];
}

- (void)registerClass:(NSString *)rowClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle
{
    NSAssert(NSClassFromString(rowClass), ([NSString stringWithFormat:@"Row class '%@' does not exist.", rowClass]));
    NSAssert(NSClassFromString(identifier), ([NSString stringWithFormat:@"Cell class '%@' does not exist.", identifier]));
    self.registeredClasses[(id <NSCopying>)NSClassFromString(rowClass)] = NSClassFromString(identifier);
    
    if (!bundle)
    {
        bundle = [NSBundle mainBundle];
    }
    
    if ([bundle pathForResource:identifier ofType:@"nib"]) {
        self.registeredXIBs[identifier] = rowClass;
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:bundle] forCellReuseIdentifier:rowClass];
    }else{
        [self.tableView registerClass:NSClassFromString(identifier) forCellReuseIdentifier:identifier];
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
    UITableViewCell<DJTableViewVMCellDelegate> *cell = [self dj_tableView:tableView cellForRowAtIndexPath:indexPath];
    
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DJTableViewVMSection *sectionVM = [self.mutableSections objectAtIndex:indexPath.section];
        DJTableViewVMRow *rowVM = [sectionVM.rows objectAtIndex:indexPath.row];
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
    }else{
        
    }
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED
{
    //TODO:
    if ([self.dataSource conformsToProtocol:@protocol(UITableViewDataSource)] && [self.dataSource respondsToSelector:@selector(sectionIndexTitlesForTableView:)]) {
        [self.dataSource sectionIndexTitlesForTableView:tableView];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED
{
    //TODO:
    if ([self.dataSource conformsToProtocol:@protocol(UITableViewDataSource)] && [self.dataSource respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)]) {
        [self.dataSource tableView:tableView sectionForSectionIndexTitle:title atIndex:index];
    }
    return 0;
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
- (UITableViewCell<DJTableViewVMCellDelegate> *)dj_tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    UITableViewCell<DJTableViewVMCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[cellClass alloc] initWithStyle:cellStyle reuseIdentifier:cellIdentifier];
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
        UITableViewCell<DJTableViewVMCellDelegate> *templateLayoutCell = [self dj_tableView:self.tableView cellForRowAtIndexPath:indexPath];
        
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

@end
