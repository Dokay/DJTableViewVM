//
//  DJTableViewVMChooseBaseCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>
#import "DJTableViewVMRow.h"

@interface DJTableViewVMChooseBaseCell : DJTableViewVMCell

@property(nonatomic, strong) DJTableViewVMRow *rowVM;

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) DJToolBar *inputAccessoryView;
@property(nonatomic, strong) UILabel *placeholderLabel;

- (void)updateWithValue:(NSObject *)newValue;

@end
