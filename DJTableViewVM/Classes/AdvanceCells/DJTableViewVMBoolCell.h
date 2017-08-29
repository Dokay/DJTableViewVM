//
//  DJTableViewVMBoolCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMCell.h"
#import "DJTableViewVMBoolRow.h"

@interface DJTableViewVMBoolCell : DJTableViewVMCell

@property(nonatomic, strong) DJTableViewVMBoolRow *rowVM;
@property(nonatomic, readonly) UISwitch *switchView;

@end
