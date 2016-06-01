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

@interface DJTableViewVM: NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) id<DJTableViewVMDelegate> delegate;
@property (nonatomic, weak) id<DJTableViewVMDataSource> dataSource;
@property (nonatomic, strong) NSMutableDictionary *registeredClasses;
@property (nonatomic, strong) NSArray *sections;

- (id)initWithTableView:(UITableView *)tableView delegate:(id<DJTableViewVMDelegate>)delegate;
- (id)initWithTableView:(UITableView *)tableView;

- (void)registerClass:(NSString *)rowClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(NSString *)rowClass forCellWithReuseIdentifier:(NSString *)identifier bundle:(NSBundle *)bundle;

/**
 *  cacultate height auto
 *
 *  @param indexPath positon of Cell
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
