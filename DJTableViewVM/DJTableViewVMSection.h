//
//  DJComponentTableViewVMSection.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class DJTableViewVM;

@interface DJTableViewVMSection : NSObject

@property (strong, readonly, nonatomic) NSArray *rows;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSString *footerTitle;
@property (nonatomic, copy) NSString *sectionIndexTitle;
@property (assign, readonly, nonatomic) NSUInteger index;
@property (weak, nonatomic) DJTableViewVM *tableViewVM;

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle;
+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;
+ (instancetype)sectionWithHeaderView:(UIView *)headerView;
+ (instancetype)sectionWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)fheight andFooterHeight:(CGFloat)fheight;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)fheight;

- (id)initWithHeaderTitle:(NSString *)headerTitle;
- (id)initWithHeaderView:(UIView *)headerView;
- (id)initWithHeaderView:(UIView *)headerView footerView:(UIView *)footerView;
- (id)initWithHeaderTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

- (void)addRow:(id)row;
- (void)addRowsFromArray:(NSArray *)array;
- (void)insertRow:(id)row atIndex:(NSUInteger)index;
- (void)removeRow:(id)row;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)removeAllRows;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end
