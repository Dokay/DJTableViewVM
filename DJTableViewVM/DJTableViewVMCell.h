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

@property (weak, nonatomic  ) UITableView           *parentTableView;
@property (weak, nonatomic  ) DJTableViewVM *tableViewVM;
@property (weak, nonatomic  ) DJTableViewVMSection *section;
@property (strong, nonatomic) DJTableViewVMRow     *rowVM;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@optional
+ (CGFloat)heightWithRow:(DJTableViewVMRow *)row tableViewVM:(DJTableViewVM *)tableViewVM;

@end

@interface DJTableViewVMCell : UITableViewCell<DJTableViewVMCellDelegate>

@property (weak, nonatomic  ) UITableView           *parentTableView;
@property (weak, nonatomic  ) DJTableViewVM *tableViewVM;
@property (weak, nonatomic  ) DJTableViewVMSection *section;
@property (strong, nonatomic) DJTableViewVMRow     *rowVM;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) NSInteger sectionIndex;
@property (nonatomic, assign) BOOL loaded;

+ (CGFloat)heightWithRow:(DJTableViewVMRow *)row tableViewVM:(DJTableViewVM *)tableViewVM;

- (void)cellDidLoad;
- (void)cellWillAppear;
- (void)cellDidDisappear;

@end
