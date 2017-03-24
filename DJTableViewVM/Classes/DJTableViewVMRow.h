//
//  DJComponentTableViewVMRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

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

@property (nonatomic,   weak, nullable) DJTableViewVMSection *sectionVM;
@property (nonatomic, strong, nullable) UIView   *accessoryView;
@property (nonatomic,   copy, nullable) NSString *cellIdentifier;
@property (nonatomic,   copy, nullable) NSArray  *editActions NS_AVAILABLE_IOS(8_0);

@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong, nullable) UIImage *highlightedImage;
@property (nonatomic, strong, nullable) UIColor   *backgroundColor;

@property (nonatomic, strong, nullable) NSString *title;
@property (nonatomic, strong, nullable) UIColor  *titleColor;
@property (nonatomic, strong, nullable) UIFont   *titleFont;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;

@property (nonatomic, strong, nullable) NSString *detailText;
@property (nonatomic, strong, nullable) UIColor  *detailTitleColor;
@property (nonatomic, strong, nullable) UIFont   *detailTitleFont;

@property (nonatomic, assign) CGFloat indentationWidth;
@property (nonatomic, assign) CGFloat indentationLevel;

@property (nonatomic, strong, nullable) NSObject *paramObject;
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;

@property (nonatomic, assign) CGFloat  cellHeight;
@property (nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType  accessoryType;
@property (nonatomic, assign) UITableViewCellEditingStyle   editingStyle;
@property (nonatomic, assign) UIEdgeInsets separatorInset;

@property (nonatomic, assign) DJCellSeparatorLineType separatorLineType;
@property (nonatomic, assign) DJCellHeightCaculateType heightCaculateType;
@property (nonatomic, assign) BOOL dj_caculateHeightForceRefresh;

#pragma mark - actions
@property (nonatomic, copy, nullable) void (^selectionHandler)(id rowVM);
@property (nonatomic, copy, nullable) void (^accessoryButtonTapHandler)(id rowVM);
@property (nonatomic, copy, nullable) BOOL (^moveCellHandler)(id rowVM,  NSIndexPath * sourceIndexPath, NSIndexPath * destinationIndexPath);
@property (nonatomic, copy, nullable) void (^moveCellCompletionHandler)(id rowVM, NSIndexPath * sourceIndexPath, NSIndexPath * destinationIndexPath);

@property (nonatomic, copy, nullable) void(^prefetchHander)(id rowVM);
@property (nonatomic, copy, nullable) void(^prefetchCancelHander)(id rowVM);

@property (nonatomic, copy, nullable) void(^deleteCellHandler)(id rowVM);
@property (nonatomic, copy, nullable) void(^deleteCellCompleteHandler)(id rowVM,  void(^ completion)());
@property (nonatomic, copy, nullable) void(^insertCellHandler)(id rowVM);

@property (nonatomic, copy, nullable) void (^cutHandler)(id rowVM);
@property (nonatomic, copy, nullable) void (^copyHandler)(id rowVM);
@property (nonatomic, copy, nullable) void (^pasteHandler)(id rowVM);

+ (instancetype)row;

- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

NS_ASSUME_NONNULL_END


@end
