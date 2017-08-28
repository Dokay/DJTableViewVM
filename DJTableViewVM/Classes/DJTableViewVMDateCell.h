//
//  DJTableViewVMDateCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMChooseBaseCell.h"
#import "DJTableViewVMDateRow.h"

@interface DJTableViewVMDateCell : DJTableViewVMChooseBaseCell

@property(nonatomic, strong) DJTableViewVMDateRow *rowVM;
@property(nonatomic, readonly) UIDatePicker *datePicker;

@end
