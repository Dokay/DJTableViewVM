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

@protocol DJTableViewVMDelegate <UITableViewDelegate>

@optional
- (void)tableView:(nonnull UITableView *)tableView willLoadCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)tableView:(nonnull UITableView *)tableView didLoadCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

//- (void)tableView:(UITableView *)tableView cellWillAppear:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DJTableViewVMDataSource <UITableViewDataSource>

@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
@protocol DJTableViewDataSourcePrefetching <NSObject>
- (void)tableView:(nonnull UITableView *)tableView prefetchRowsAtIndexPaths:(nullable NSArray *)indexPaths;

- (void)tableView:(nonnull UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(nullable NSArray *)indexPaths;
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
@property (nonatomic, strong, readonly, nullable) NSArray *sections;
@property (nonatomic, assign) CGFloat rowHeight;             // will return the default value if unset
@property (nonatomic, assign) CGFloat sectionHeaderHeight;   // will return the default value if unset
@property (nonatomic, assign) CGFloat sectionFooterHeight;   // will return the default value if unset
@property (nonatomic, assign) CGFloat estimatedRowHeight;
@property (nonatomic, assign) CGFloat estimatedSectionHeaderHeight;
@property (nonatomic, assign) CGFloat estimatedSectionFooterHeight;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, strong, nullable) UIColor *separatorColor;
@property (nonatomic, strong, nullable) UIView *tableHeaderView;
@property (nonatomic, strong, nullable) UIView *tableFooterView;
@property (nonatomic, strong, nullable) UIView *backgroundView;

- (nonnull id)initWithTableView:(nonnull UITableView *)tableView delegate:(nullable id<DJTableViewVMDelegate>)delegate;
- (nonnull id)initWithTableView:(nonnull UITableView *)tableView;

- (void)registerRowClass:(nonnull NSString *)rowClass forCellClass:(nonnull NSString *)cellClass;
- (void)registerRowClass:(nonnull NSString *)rowClass forCellClass:(nonnull NSString *)cellClass bundle:(nullable NSBundle *)bundle;

/**
 *  cacultate height auto
 *
 *  @param indexPath of Cell
 *
 *  @return height of cell
 */
- (CGFloat)heightWithAutoLayoutCellWithIndexPath:(nonnull NSIndexPath *)indexPath;

#pragma mark - implement dictionary key value style
- (nonnull id)objectAtKeyedSubscript:(nonnull id <NSCopying>)key;
- (void)setObject:(nonnull id)obj forKeyedSubscript:(nonnull id <NSCopying>)key;

- (void)addSection:(nonnull DJTableViewVMSection *)section;
- (void)addSectionsFromArray:(nonnull NSArray *)array;
- (void)insertSection:(nonnull DJTableViewVMSection *)section atIndex:(NSUInteger)index;
- (void)removeSection:(nonnull DJTableViewVMSection *)section;
- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsInArray:(nonnull NSArray *)otherArray;
- (void)removeAllSections;

@end
