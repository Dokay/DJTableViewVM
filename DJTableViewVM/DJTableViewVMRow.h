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

@property (assign, nonatomic) CGFloat                       cellHeight;
@property (assign, nonatomic) UITableViewCellStyle          style;
@property (weak, nonatomic  ) DJTableViewVMSection         *section;
@property (strong, nonatomic) UIView                        *accessoryView;
@property (copy, nonatomic  ) NSString                      *cellIdentifier;
@property (assign, nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property (assign, nonatomic) UITableViewCellAccessoryType  accessoryType;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0) UI_APPEARANCE_SELECTOR; // allows customization of the frame of cell separators
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


@property (copy, nonatomic) void (^selectionHandler)(id rowVM);
@property (copy, nonatomic) BOOL (^moveHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);
@property (copy, nonatomic) void (^moveCompletionHandler)(id rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);


+ (instancetype)row;

- (NSIndexPath *)indexPath;
- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;


@end
