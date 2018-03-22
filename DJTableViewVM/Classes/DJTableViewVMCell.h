//
//  DJComponentTableViewVMCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTableViewVMRow.h"

NS_ASSUME_NONNULL_BEGIN

#define DJRectSetLeft(view,left_value) (view).frame = CGRectMake((left_value), (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height)
#define DJRectSetRight(view,right_value) (view).frame = CGRectMake(self.contentView.frame.size.width - (view).frame.size.width - right_value, (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height)

@class DJTableViewVM;
@class DJTableViewVMRow;
@class DJTableViewVMSection;

@protocol DJTableViewVMCellDelegate <NSObject>

@required
/**
 UITableView that hold cell.
 */
@property (nonatomic, weak) UITableView *parentTableView;

/**
 row view model for cell.
 */
@property (nonatomic, strong) DJTableViewVMRow *rowVM;

/**
 whether current cell is loaded,after cell is loaded ,cellDidLoad will never called.
 */
@property (nonatomic, assign) BOOL loaded;

/**
 caculate height for cell

 @param rowVM rowVM relate to current cell
 @param tableViewVM tableViewVM related to current cell
 @return height for current cell
 */
+ (CGFloat)heightWithRow:(DJTableViewVMRow *)rowVM tableViewVM:(DJTableViewVM *)tableViewVM;

/**
 celled when cell is first init,only called once.like viewDidLoad in UIViewController.you can build your view here.
 */
- (void)cellDidLoad;

/**
 called when cell will show every time,like viewWillAppear in UIViewController.you can update your view here.
 */
- (void)cellWillAppear;

@optional

/**
 called when main thread's runloop is idle,while user drag tableView or tableView scroll for decelerate this method will not called.heavy task to update view like set image to imageView belong to here.
 */
- (void)cellLazyTask;

/**
 called when UITableViewDelegate method tableView: didEndDisplayingCell: forRowAtIndexPath: be called.
 */
- (void)cellDidDisappear;

@end

@interface DJTableViewVMCell : UITableViewCell<DJTableViewVMCellDelegate>

@property (weak, nonatomic, nullable) UITableView *parentTableView;
@property (strong, nonatomic) DJTableViewVMRow *rowVM;
@property (nonatomic, assign) BOOL loaded;

+ (CGFloat)heightWithRow:(DJTableViewVMRow *)rowVM tableViewVM:(DJTableViewVM *)tableViewVM;

#pragma mark - life cycle
- (void)cellDidLoad;
- (void)cellWillAppear;

@end

NS_ASSUME_NONNULL_END
