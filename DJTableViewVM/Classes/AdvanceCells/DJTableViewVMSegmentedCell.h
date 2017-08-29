//
//  DJTableViewVMSegmentedCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMCell.h"
#import "DJTableViewVMSegmentedRow.h"

@interface DJTableViewVMSegmentedCell : DJTableViewVMCell

@property(nonatomic, readonly) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) DJTableViewVMSegmentedRow *rowVM;

@end
