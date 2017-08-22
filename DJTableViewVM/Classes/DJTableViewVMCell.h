//
//  DJComponentTableViewVMCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DJRectSetLeft(view,left_value) (view).frame = CGRectMake((left_value), (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height)
#define DJRectSetRight(view,right_value) (view).frame = CGRectMake(self.contentView.frame.size.width - (view).frame.size.width - right_value, (view).frame.origin.y, (view).frame.size.width, (view).frame.size.height)

@class DJTableViewVM;
@class DJTableViewVMRow;
@class DJTableViewVMSection;

@protocol DJTableViewVMCellDelegate <NSObject>

@required
@property (nonatomic, weak) UITableView *parentTableView;
@property (nonatomic, strong) DJTableViewVMRow *rowVM;
@property (nonatomic, assign) BOOL loaded;

+ (CGFloat)heightWithRow:(DJTableViewVMRow *)row tableViewVM:(DJTableViewVM *)tableViewVM;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@end

@interface DJTableViewVMCell : UITableViewCell<DJTableViewVMCellDelegate>

@property (weak, nonatomic, nullable) UITableView *parentTableView;
@property (strong, nonatomic) DJTableViewVMRow *rowVM;
@property (nonatomic, assign) BOOL loaded;

+ (CGFloat)heightWithRow:(DJTableViewVMRow *)row tableViewVM:(DJTableViewVM *)tableViewVM;

#pragma mark - life cycle
- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

NS_ASSUME_NONNULL_END

@end
