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

@property (nonatomic,   weak) DJTableViewVMSection *section;
@property (nonatomic, assign) CGFloat  cellHeight;
@property (nonatomic, strong) UIView   *accessoryView;
@property (nonatomic,   copy) NSString *cellIdentifier;
@property (nonatomic,   copy) NSArray  *editActions NS_AVAILABLE_IOS(8_0);
@property (nonatomic, assign) UITableViewCellStyle style;
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic, assign) UITableViewCellAccessoryType  accessoryType;
@property (nonatomic, assign) UITableViewCellEditingStyle   editingStyle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (nonatomic, strong) UIColor   *backgroundColor;
@property (nonatomic, strong) UIColor   *titleColor;
@property (nonatomic, strong) UIFont    *titleFont;
@property (nonatomic, strong) UIColor   *detailTitleColor;
@property (nonatomic, strong) UIFont    *detailTitleFont;
@property (nonatomic, strong) NSObject  *paramObject;

@property (nonatomic, assign) DJCellSeparatorLineType separatorLineType;
@property (nonatomic, assign) DJCellHeightCaculateType heightCaculateType;
@property (nonatomic, assign) BOOL dj_caculateHeightForceRefresh;

#pragma mark - actions
@property (nonatomic, copy) void (^selectionHandler)(id rowVM);
@property (nonatomic, copy) void (^accessoryButtonTapHandler)(id rowVM);
@property (nonatomic, copy) BOOL (^moveCellHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (nonatomic, copy) void (^moveCellCompletionHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

@property (nonatomic, copy) void(^prefetchHander)(id rowVM);
@property (nonatomic, copy) void(^prefetchCancelHander)(id rowVM);

@property (nonatomic, copy) void(^deleteCellHandler)(id rowVM);
@property (nonatomic, copy) void(^deleteCellCompleteHandler)(id rowVM,void(^completion)());
@property (nonatomic, copy) void(^insertCellHandler)(id rowVM);

@property (copy, readwrite, nonatomic) void (^cutHandler)(id rowVM);
@property (copy, readwrite, nonatomic) void (^copyHandler)(id rowVM);
@property (copy, readwrite, nonatomic) void (^pasteHandler)(id rowVM);

+ (instancetype)row;

- (NSIndexPath *)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;


@end
