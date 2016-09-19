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

@property (strong, readonly, nonatomic, nullable) NSArray *rows;
@property (strong, nonatomic, nullable) UIView *headerView;
@property (strong, nonatomic, nullable) UIView *footerView;
@property (nonatomic, copy, nullable) NSString *headerTitle;
@property (nonatomic, copy, nullable) NSString *footerTitle;
@property (nonatomic, copy, nullable) NSString *sectionIndexTitle;
@property (assign, readonly, nonatomic) NSUInteger index;
@property (weak, nonatomic, nullable) DJTableViewVM *tableViewVM;

+ (nonnull instancetype)sectionWithHeaderTitle:(nullable NSString *)headerTitle;
+ (nonnull instancetype)sectionWithHeaderTitle:(nullable NSString *)headerTitle footerTitle:(nullable NSString *)footerTitle;
+ (nonnull instancetype)sectionWithHeaderView:(nullable UIView *)headerView;
+ (nonnull instancetype)sectionWithHeaderView:(nullable UIView *)headerView footerView:(nullable UIView *)footerView;
+ (nonnull instancetype)sectionWithHeaderHeight:(CGFloat)fheight andFooterHeight:(CGFloat)fheight;
+ (nonnull instancetype)sectionWithHeaderHeight:(CGFloat)fheight;

- (nonnull id)initWithHeaderTitle:(nullable NSString *)headerTitle;
- (nonnull id)initWithHeaderView:(nullable UIView *)headerView;
- (nonnull id)initWithHeaderView:(nullable UIView *)headerView footerView:(nullable UIView *)footerView;
- (nonnull id)initWithHeaderTitle:(nullable NSString *)headerTitle footerTitle:(nullable NSString *)footerTitle;

- (void)addRow:(nonnull id)row;
- (void)addRowsFromArray:(nullable NSArray *)array;
- (void)insertRow:(nonnull id)row atIndex:(NSUInteger)index;
- (void)removeRow:(nonnull id)row;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)removeAllRows;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end
