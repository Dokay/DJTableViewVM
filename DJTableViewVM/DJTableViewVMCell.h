//
//  DJComponentTableViewVMCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DJTableViewVMRow.h"
@class DJTableViewVM;
@class DJTableViewVMSection;

@protocol DJTableViewVMCellDelegate <NSObject>

@property (weak, nonatomic, nullable) UITableView *parentTableView;
@property (weak, nonatomic, nullable) DJTableViewVM *tableViewVM;
@property (weak, nonatomic, nullable) DJTableViewVMSection *section;
@property (strong, nonatomic, nonnull) DJTableViewVMRow *rowVM;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@optional
+ (CGFloat)heightWithRow:(nonnull DJTableViewVMRow *)row tableViewVM:(nonnull DJTableViewVM *)tableViewVM;

@end

@interface DJTableViewVMCell : UITableViewCell<DJTableViewVMCellDelegate>

@property (weak, nonatomic, nullable) UITableView *parentTableView;
@property (weak, nonatomic, nullable) DJTableViewVM *tableViewVM;
@property (weak, nonatomic, nullable) DJTableViewVMSection *section;
@property (strong, nonatomic, nonnull) DJTableViewVMRow *rowVM;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

+ (CGFloat)heightWithRow:(nonnull DJTableViewVMRow *)row tableViewVM:(nonnull DJTableViewVM *)tableViewVM;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@end
