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
    DJCellHeightCaculateDefault,//return from class method heightWithRow:tableViewVM: of DJTableViewVMRow,default is value of cellHeight
    DJCellHeightCaculateAutoFrameLayout,//auto caculate with frame layout
    DJCellHeightCaculateAutoLayout,//auto caculate with autolayout
};

@class DJTableViewVMSection;

@interface DJTableViewVMRow : NSObject

@property (nonatomic,   weak, nullable) DJTableViewVMSection *sectionVM;

#pragma mark - cell propertis
/**
 accessoryView of cell,default is nil.
 */
@property (nonatomic, strong, nullable) UIView   *accessoryView;

/**
 image of imageView property in cell.default is nil.
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 highlightedImage of imageView property in cell.default is nil.
 */
@property (nonatomic, strong, nullable) UIImage *highlightedImage;

/**
 accessoryView of cell,default is white color.
 */
@property (nonatomic, strong, nullable) UIColor *backgroundColor;

/**
 style of cell,default is UITableViewCellStyleDefault.
 */
@property (nonatomic, assign) UITableViewCellStyle style;

/**
 selectionStyle of cell, default is UITableViewCellSelectionStyleNone.
 */
@property (nonatomic, assign) UITableViewCellSelectionStyle selectionStyle;

/**
 accessoryType of cell, default is UITableViewCellAccessoryNone.
 */
@property (nonatomic, assign) UITableViewCellAccessoryType  accessoryType;

/**
 edit actions for tableView: editActionsForRowAtIndexPath:
 */
@property (nonatomic, copy, nullable) NSArray *editActions NS_AVAILABLE_IOS(8_0);

/**
 editingStyle of cell, default is UITableViewCellEditingStyleNone.set style you want and use block actions to process user action.
 */
@property (nonatomic, assign) UITableViewCellEditingStyle editingStyle;
/**
 identifier of cell,DJTableViewVM use it to dequeue reuse cell.use DJTableViewRegister macro to regist cells.
 */
@property (nonatomic, copy, nullable) NSString *cellIdentifier;

#pragma mark - title properties
/**
 text property of textLabel in cell.default is nil.
 */
@property (nonatomic, copy, nullable) NSString *title;

/**
  attributedText property of textLabel in cell.default is nil.
 */
@property (nonatomic, copy) NSAttributedString *titleAttributedString;

/**
 textColor property of textLabel in cell.default is black color.
 */
@property (nonatomic, strong, nullable) UIColor *titleColor;

/**
 font property of textLabel in cell.default is system font with 17.0f.
 */
@property (nonatomic, strong, nullable) UIFont *titleFont;

/**
 textAlignment property of textLabel in cell.default is NSTextAlignmentLeft.
 */
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;

#pragma mark -subtitle properties
/**
 title property of detailTextLabel in cell.default is nil.
 */
@property (nonatomic, copy, nullable) NSString *detailText;

/**
 attributedText property of detailTextLabel in cell.default is nil.
 */
@property (nonatomic, copy, nullable) NSAttributedString *detailAttributedString;

/**
 textColor property of detailTextLabel in cell.default is 70% gray.
 */
@property (nonatomic, strong, nullable) UIColor *detailTextColor;

/**
 font property of detailTextLabel in cell.default is system font with 17.0f.
 */
@property (nonatomic, strong, nullable) UIFont *detailTextFont;

#pragma mark - margin control
/**
 label edge of labels.detault is (10, 15, 10, 15)
 */
@property (nonatomic, assign) UIEdgeInsets elementEdge;

/**
 control separator line margin.default value is (0, 15, 0, 0).
 */
@property (nonatomic, assign) UIEdgeInsets separatorInset;

/**
 cell height of current cell.deffault is 0.
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 whether cell is edit enable.default is YES.
 */
@property (nonatomic, assign) BOOL enabled;

/**
 associated parameter object.default is nil.
 */
@property (nonatomic, strong, nullable) NSObject *paramObject;

/**
 indexPath of cell in tableView.
 */
@property (nonatomic, strong, readonly) NSIndexPath *indexPath;

/**
 whether separator is visable.default is DJCellSeparatorLineDefault.
 */
@property (nonatomic, assign) DJCellSeparatorLineType separatorLineType;

/**
 height caculate type of cell,default is DJCellHeightCaculateDefault.
 */
@property (nonatomic, assign) DJCellHeightCaculateType heightCaculateType;

/**
 height cache is open default , so it is caculated only once.when dj_caculateHeightForceRefresh set YES,cell's height will be recaculated when cell appears next time.default is NO.
 */
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

/**
 used to show a placeholder cell.

 @param color placeholder color
 @param height placeholder height
 @return placeholder row
 */
+ (instancetype)rowWithPlaceHolderColor:(UIColor *)color andHeight:(CGFloat)height;

/**
 get default style instance,change it's property to change default value global.

 @return default style instance
 */
+ (instancetype)defaultStyleInstance;

- (void)selectRowAnimated:(BOOL)animated;
- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition;
- (void)deselectRowAnimated:(BOOL)animated;
- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation;

NS_ASSUME_NONNULL_END


@end
