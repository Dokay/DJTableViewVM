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
- (void)tableView:(UITableView *)tableView willLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView didLoadCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

//- (void)tableView:(UITableView *)tableView cellWillAppear:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol DJTableViewVMDataSource <UITableViewDataSource>

@end

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
@protocol DJTableViewDataSourcePrefetching <NSObject>
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray *)indexPaths;

- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray *)indexPaths;
@end
#else
@protocol DJTableViewDataSourcePrefetching <UITableViewDataSourcePrefetching>

@end
#endif



@interface DJTableViewVM: NSObject <UITableViewDelegate, UITableViewDataSource,DJTableViewDataSourcePrefetching>

@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, weak) id<DJTableViewVMDelegate> delegate;
@property (nonatomic, weak) id<DJTableViewVMDataSource> dataSource;
@property (nonatomic, weak) id<DJTableViewDataSourcePrefetching> prefetchDataSource;
@property (nonatomic, strong) NSArray *sections;
@property (nonatomic, assign) CGFloat rowHeight;             // will return the default value if unset
@property (nonatomic, assign) CGFloat sectionHeaderHeight;   // will return the default value if unset
@property (nonatomic, assign) CGFloat sectionFooterHeight;   // will return the default value if unset
@property (nonatomic, assign) CGFloat estimatedRowHeight;
@property (nonatomic, assign) CGFloat estimatedSectionHeaderHeight;
@property (nonatomic, assign) CGFloat estimatedSectionFooterHeight;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIView *backgroundView;

- (id)initWithTableView:(UITableView *)tableView delegate:(id<DJTableViewVMDelegate>)delegate;
- (id)initWithTableView:(UITableView *)tableView;

- (void)registerRowClass:(NSString *)rowClass forCellClass:(NSString *)cellClass;
- (void)registerRowClass:(NSString *)rowClass forCellClass:(NSString *)cellClass bundle:(NSBundle *)bundle;

/**
 *  cacultate height auto
 *
 *  @param indexPath of Cell
 *
 *  @return height of cell
 */
- (CGFloat)heightWithAutoLayoutCellWithIndexPath:(NSIndexPath *)indexPath;

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
