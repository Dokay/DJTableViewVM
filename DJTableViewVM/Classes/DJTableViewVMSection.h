//
//  DJComponentTableViewVMSection.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@class DJTableViewVM;

@interface DJTableViewVMSection : NSObject

@property (nonatomic, strong, readonly,nullable) NSArray *rows;
@property (nonatomic, strong, nullable) UIView *headerView;
@property (nonatomic, strong, nullable) UIView *footerView;
@property (nonatomic, copy, nullable) NSString *headerTitle;
@property (nonatomic, copy, nullable) NSString *footerTitle;
@property (nonatomic, copy, nullable) NSString *sectionIndexTitle;
@property (nonatomic, weak, nullable) DJTableViewVM *tableViewVM;
@property (nonatomic, readonly, assign) NSUInteger index;

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle;
+ (instancetype)sectionWithHeaderTitle:(nullable NSString *)headerTitle footerTitle:(nullable NSString *)footerTitle;
+ (instancetype)sectionWithHeaderView:(UIView *)headerView;
+ (instancetype)sectionWithFooterView:(UIView *)footerView;
+ (instancetype)sectionWithHeaderView:(nullable UIView *)headerView footerView:(nullable UIView *)footerView;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)height andFooterHeight:(CGFloat)height;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)height;
+ (instancetype)sectionWithFooterHeight:(CGFloat)height;

- (id)initWithHeaderTitle:(NSString *)headerTitle;
- (id)initWithHeaderView:(UIView *)headerView;
- (id)initWithHeaderView:(nullable UIView *)headerView footerView:(nullable UIView *)footerView;
- (id)initWithHeaderTitle:(nullable NSString *)headerTitle footerTitle:(nullable NSString *)footerTitle;

- (void)addRow:(id)row;
- (void)addRowsFromArray:(NSArray *)array;
- (void)insertRow:(id)row atIndex:(NSUInteger)index;
- (void)removeRow:(id)row;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)removeAllRows;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
