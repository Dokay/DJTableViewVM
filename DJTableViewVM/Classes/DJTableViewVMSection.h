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

typedef NS_ENUM(NSInteger,DJSectionHeightCaculateType){
    DJSectionHeightCaculateTypeDefault,//using height of headerView' frame.
    DJSectionHeightCaculateTypeAutomatic,//auto caclulate with autolayout of headerView's subviews.
};

@class DJTableViewVM;

@interface DJTableViewVMSection : NSObject

@property (nonatomic, weak, nullable) DJTableViewVM *tableViewVM;
@property (nonatomic, strong, readonly,nullable) NSArray *rows;
@property (nonatomic, strong, nullable) UIView *headerView;
@property (nonatomic, strong, nullable) UIView *footerView;
@property (nonatomic, copy, nullable) NSString *headerTitle;
@property (nonatomic, copy, nullable) NSString *footerTitle;
@property (nonatomic, copy, nullable) NSString *sectionIndexTitle;
@property (nonatomic, readonly, assign) NSUInteger index;

@property (nonatomic, assign) DJSectionHeightCaculateType headerHeightCaculateType;
@property (nonatomic, assign) DJSectionHeightCaculateType footerHeightCaculateType;
@property (nonatomic, strong, readonly) NSMutableDictionary *automaticHeightCache;
@property (nonatomic, assign) BOOL isSectionHeightNeedRefresh;

+ (instancetype)sectionWithHeaderTitle:(NSString *)headerTitle;
+ (instancetype)sectionWithFooterTitle:(NSString *)footerTitle;
+ (instancetype)sectionWithHeaderTitle:(nullable NSString *)headerTitle footerTitle:(nullable NSString *)footerTitle;
+ (instancetype)sectionWithHeaderView:(UIView *)headerView;
+ (instancetype)sectionWithFooterView:(UIView *)footerView;
+ (instancetype)sectionWithHeaderView:(nullable UIView *)headerView footerView:(nullable UIView *)footerView;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)height andFooterHeight:(CGFloat)height;
+ (instancetype)sectionWithHeaderHeight:(CGFloat)height;
+ (instancetype)sectionWithFooterHeight:(CGFloat)height;

///get a instance with attributedString and edgeInsets for label in header view
+ (instancetype)sectionWithHeaderAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets;
///get a instance with attributedString and edgeInsets for label in footer view
+ (instancetype)sectionWithFooterAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets;

- (id)initWithHeaderTitle:(NSString *)headerTitle;
- (id)initWithFooterTitle:(NSString *)footerTitle;
- (id)initWithHeaderView:(UIView *)headerView;
- (id)initWithFooterView:(UIView *)footerView;
- (id)initWithHeaderView:(nullable UIView *)headerView footerView:(nullable UIView *)footerView;
- (id)initWithHeaderTitle:(nullable NSString *)headerTitle footerTitle:(nullable NSString *)footerTitle;

///init a instance with attributedString and edgeInsets for label in header view
- (id)initWithHeaderAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets;
///init a instance with attributedString and edgeInsets for label in footer view
- (id)initWithFooterAttributedText:(NSAttributedString *)attributedString edgeInsets:(UIEdgeInsets)edgeInsets;

- (void)addRow:(id)row;
- (void)addRowsFromArray:(NSArray *)array;
- (void)insertRow:(id)row atIndex:(NSUInteger)index;
- (void)removeRow:(id)row;
- (void)removeRowAtIndex:(NSUInteger)index;
- (void)removeAllRows;

- (void)reloadSectionWithAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
