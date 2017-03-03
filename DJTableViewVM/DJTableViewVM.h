//
//  DJComponentTableViewVM.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJTableViewVMSection.h"
#import "DJTableViewVMRow.h"

@import UIKit;

#define DJTableViewRegister(DJTableViewVMInstance,RowVMClassName,CellClassName) [DJTableViewVMInstance setObject:NSStringFromClass([CellClassName class]) forKeyedSubscript:NSStringFromClass([RowVMClassName class])];

NS_ASSUME_NONNULL_BEGIN

@protocol DJTableViewVMDelegate <UITableViewDelegate>

@optional
- (void)tableView:(UITableView *)tableView cellWillLoad:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView cellDidLoad:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView cellWillAppear:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView cellDidAppear:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000

@protocol DJTableViewDataSourcePrefetching <NSObject>
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(nullable NSArray *)indexPaths;

- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(nullable NSArray *)indexPaths;
@end

#else

@protocol DJTableViewDataSourcePrefetching <UITableViewDataSourcePrefetching>

@end

#endif

@interface DJTableViewVM: NSObject <UITableViewDelegate, UITableViewDataSource,DJTableViewDataSourcePrefetching>

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak, nullable) id<DJTableViewVMDelegate> delegate;
@property (nonatomic, weak, nullable) id<DJTableViewDataSourcePrefetching> prefetchDataSource;

#pragma mark - UITableView properties
@property (nonatomic, strong, nullable) UIColor *separatorColor;
@property (nonatomic, strong, nullable) UIView *tableHeaderView;
@property (nonatomic, strong, nullable) UIView *tableFooterView;
@property (nonatomic, strong, nullable) UIView *backgroundView;
@property (nonatomic, assign) CGFloat rowHeight;             // will return the default value if unset
@property (nonatomic, assign) UIEdgeInsets separatorInset;

#pragma mark - advanced properties
@property (nonatomic, assign) BOOL emptyLinesHide;//whether hide lines when the tableview has no enough cells to fill its bounds size. default is NO.
@property (nonatomic, assign) BOOL prefetchingEnabled;//whether prefetch enable. default is NO.
@property (nonatomic, strong, readonly, nullable) NSArray *sections;
/**
 *  whether height of cells can be caculated an cached in spare time(kCFRunLoopDefaultMode in main thread runloop).Default is NO
 */
@property (nonatomic, assign) BOOL preCaculateHeightEnable;

#pragma mark - keyboard manage
@property(nonatomic, assign) BOOL keyboardManageEnabled;//whether srcoll to target offset auto by DJTableViewVM.defalt is NO.
@property(nonatomic, assign) BOOL scrollHideKeyboadEnable;//whether hide keyboard while scroll UITableView.default is NO.
@property(nonatomic, assign) BOOL tapHideKeyboardEnable;//whether hide keyboard while tap UITableView.defailt is NO.
@property(nonatomic, assign) CGFloat offsetUnderResponder;//the offset between top of keboard and bottom of responder view.responder view is the return from cell that implemente DJInputCellProtocol. default is 10.0f.

#pragma mark - init methods
- (id)initWithTableView:(UITableView *)tableView delegate:(nullable id<DJTableViewVMDelegate>)delegate;
- (id)initWithTableView:(UITableView *)tableView;
- (void)reloadData;

/**
 *  cacultate height auto
 *
 *  @param indexPath of Cell
 *
 *  @return height of cell
 */
- (CGFloat)heightWithAutoLayoutCellForIndexPath:(NSIndexPath *)indexPath;

#pragma mark - implement dictionary key value style
- (id)objectAtKeyedSubscript:(id<NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;

#pragma mark - VM manage
- (void)addSection:(DJTableViewVMSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;
- (void)insertSection:(DJTableViewVMSection *)section atIndex:(NSUInteger)index;
- (void)removeSection:(DJTableViewVMSection *)section;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeAllSections;

@property (nonatomic, assign) CGFloat sectionHeaderHeight __deprecated_msg("sectionHeaderHeight deprecated. Use sectionWithHeaderHeight in DJTableViewVMSection instead");   // will return the default value if unset
@property (nonatomic, assign) CGFloat sectionFooterHeight __deprecated_msg("sectionFooterHeight deprecated. Use sectionWithFooterHeight in DJTableViewVMSection instead");   // will return the default value if unset
@property (nonatomic, assign) CGFloat estimatedRowHeight;
@property (nonatomic, assign) CGFloat estimatedSectionHeaderHeight __deprecated_msg("estimatedSectionHeaderHeight deprecated. Use sectionWithHeaderHeight in DJTableViewVMSection instead");
@property (nonatomic, assign) CGFloat estimatedSectionFooterHeight __deprecated_msg("estimatedSectionFooterHeight deprecated. Use sectionWithFooterHeight in DJTableViewVMSection instead");

@end

NS_ASSUME_NONNULL_END
