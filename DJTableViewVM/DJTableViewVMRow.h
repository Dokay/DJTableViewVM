//
//  DJComponentTableViewVMRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

typedef NS_ENUM(NSInteger,DJCellSeparatorLineType){
    DJCellSeparatorLineDefault,
    DJCellSeparatorLineShow,
    DJCellSeparatorLineHide,
};

typedef NS_ENUM(NSInteger,DJCellHeightCaculateType){
    DJCellHeightCaculateDefault,//default heightWithRow:tableViewVM:
    DJCellHeightCaculateAutoFrameLayout,//layout use frame layout
    DJCellHeightCaculateAutoLayout,//layout use autolayout
};

@class DJTableViewVMSection;

@interface DJTableViewVMRow : NSObject

@property (nonatomic,   weak, nullable) DJTableViewVMSection *section;
@property (nonatomic, strong, nullable) UIView   *accessoryView;
@property (nonatomic,   copy, nullable) NSString *cellIdentifier;
@property (nonatomic,   copy, nullable) NSArray  *editActions NS_AVAILABLE_IOS(8_0);
@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) NSString *detailText;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *highlightedImage;
@property (nonatomic, strong, nullable) UIColor   *backgroundColor;
@property (nonatomic, strong, nullable) UIColor   *titleColor;
@property (nonatomic, strong, nullable) UIFont    *titleFont;
@property (nonatomic, strong, nullable) UIColor   *detailTitleColor;
@property (nonatomic, strong, nullable) UIFont    *detailTitleFont;
@property (nonatomic, strong, nullable) NSObject  *paramObject;
@property (nonatomic, assign) CGFloat  cellHeight;
@property (nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType  accessoryType;
@property (nonatomic, assign) UITableViewCellEditingStyle   editingStyle;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;

@property (nonatomic, assign) DJCellSeparatorLineType separatorLineType;
@property (nonatomic, assign) DJCellHeightCaculateType heightCaculateType;
@property (nonatomic, assign) BOOL dj_caculateHeightForceRefresh;

#pragma mark - actions
@property (nonatomic, copy, nullable) void (^selectionHandler)(_Nonnull id rowVM);
@property (nonatomic, copy, nullable) void (^accessoryButtonTapHandler)(_Nonnull id rowVM);
@property (nonatomic, copy, nullable) BOOL (^moveCellHandler)(_Nonnull id rowVM,  NSIndexPath * _Nonnull sourceIndexPath, NSIndexPath * _Nonnull destinationIndexPath);
@property (nonatomic, copy, nullable) void (^moveCellCompletionHandler)(_Nonnull id rowVM, NSIndexPath * _Nonnull sourceIndexPath, NSIndexPath * _Nonnull destinationIndexPath);

@property (nonatomic, copy, nullable) void(^prefetchHander)(_Nonnull id rowVM);
@property (nonatomic, copy, nullable) void(^prefetchCancelHander)(_Nonnull id rowVM);

@property (nonatomic, copy, nullable) void(^deleteCellHandler)(_Nonnull id rowVM);
@property (nonatomic, copy, nullable) void(^deleteCellCompleteHandler)(_Nonnull id rowVM,  void(^ _Nonnull completion)());
@property (nonatomic, copy, nullable) void(^insertCellHandler)(_Nonnull id rowVM);

@property (nonatomic, copy, nullable) void (^cutHandler)(_Nonnull id rowVM);
@property (nonatomic, copy, nullable) void (^copyHandler)(_Nonnull id rowVM);
@property (nonatomic, copy, nullable) void (^pasteHandler)(_Nonnull id rowVM);

+ (_Nonnull instancetype)row;

- (NSIndexPath * _Nonnull)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;


@end
