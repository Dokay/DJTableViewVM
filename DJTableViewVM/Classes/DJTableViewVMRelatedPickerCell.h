//
//  DJTableViewVMRelatedPickerCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMChooseBaseCell.h"
#import "DJTableViewVMRelatedPickerRow.h"

@interface DJTableViewVMRelatedPickerCell : DJTableViewVMChooseBaseCell

@property(nonatomic, strong) DJTableViewVMRelatedPickerRow *rowVM;
@property(nonatomic, strong) UIPickerView *pickerView;

@end
