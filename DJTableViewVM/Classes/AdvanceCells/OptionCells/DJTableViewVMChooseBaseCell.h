//
//  DJTableViewVMChooseBaseCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMCell.h"
#import "DJTableViewVMRow.h"
#import "DJToolBar.h"

@interface DJTableViewVMChooseBaseCell : DJTableViewVMCell

@property(nonatomic, strong) DJTableViewVMRow *rowVM;

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) UILabel *placeholderLabel;

- (void)updateWithValue:(NSObject *)newValue;

@end
