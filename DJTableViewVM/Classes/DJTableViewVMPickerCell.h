//
//  DJTableViewVMPickerCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>
#import "DJTableViewVMPickerRow.h"

@interface DJTableViewVMPickerCell : DJTableViewVMCell

@property(nonatomic, strong) DJTableViewVMPickerRow *rowVM;
@property(nonatomic, strong) UIPickerView *pickerView;

@end
