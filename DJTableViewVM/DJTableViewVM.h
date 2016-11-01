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

NS_ASSUME_NONNULL_BEGIN

@protocol DJTableViewVMDelegate <UITableViewDelegate>

@optional
- (void)tableView:(UITableView *)tableView cellWillLoad:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView cellDidLoad:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView cellWillAppear:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView cellDidAppear:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DJTableViewVMDataSource <UITableViewDataSource>

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

@property (nonatomic, weak, readonly, nullable) UITableView *tableView;
@property (nonatomic, weak, nullable) id<DJTableViewVMDelegate> delegate;
@property (nonatomic, weak, nullable) id<DJTableViewVMDataSource> dataSource;
@property (nonatomic, weak, nullable) id<DJTableViewDataSourcePrefetching> prefetchDataSource;

@property (nonatomic, strong, nullable) UIColor *separatorColor;
@property (nonatomic, strong, nullable) UIView *tableHeaderView;
@property (nonatomic, strong, nullable) UIView *tableFooterView;
@property (nonatomic, strong, nullable) UIView *backgroundView;
@property (nonatomic, assign) CGFloat rowHeight;             // will return the default value if unset
@property (nonatomic, assign) UIEdgeInsets separatorInset;

@property (nonatomic, strong, readonly, nullable) NSArray *sections;
@property (nonatomic, assign) BOOL prefetchingEnabled;

/**
 *  Default is NO.Control whether height of cells can be caculated an cached in spare time(kCFRunLoopDefaultMode in main thread runloop).
 */
@property (nonatomic, assign) BOOL preCaculateHeightEnable;

@property (nonatomic, assign) CGFloat sectionHeaderHeight __deprecated_msg("sectionHeaderHeight deprecated. Use sectionWithHeaderHeight instead");   // will return the default value if unset
@property (nonatomic, assign) CGFloat sectionFooterHeight __deprecated_msg("sectionFooterHeight deprecated. Use sectionWithFooterHeight instead");   // will return the default value if unset
@property (nonatomic, assign) CGFloat estimatedRowHeight;
@property (nonatomic, assign) CGFloat estimatedSectionHeaderHeight __deprecated_msg("estimatedSectionHeaderHeight deprecated. Use sectionWithHeaderHeight instead");
@property (nonatomic, assign) CGFloat estimatedSectionFooterHeight __deprecated_msg("estimatedSectionFooterHeight deprecated. Use sectionWithFooterHeight instead");

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
- (id)objectAtKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

- (void)addSection:(DJTableViewVMSection *)section;
- (void)addSectionsFromArray:(NSArray *)array;
- (void)insertSection:(DJTableViewVMSection *)section atIndex:(NSUInteger)index;
- (void)removeSection:(DJTableViewVMSection *)section;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsInArray:(NSArray *)otherArray;
- (void)removeAllSections;

@end

NS_ASSUME_NONNULL_END
