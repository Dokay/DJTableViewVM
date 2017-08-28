//
//  DJTableViewVMPickerCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMPickerRow.h"
#import "DJTableViewVMChooseBaseCell.h"

@interface DJTableViewVMPickerCell : DJTableViewVMChooseBaseCell

@property(nonatomic, strong) DJTableViewVMPickerRow *rowVM;
@property(nonatomic, readonly) UIPickerView *pickerView;

@end
