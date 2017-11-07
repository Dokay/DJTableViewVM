//
//  DJTableViewVMTextFieldCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/16.
//  Copyright © 2017年 dj226. All rights reserved.
//

@import Foundation;
#import "DJTableViewVMCell.h"
#import "DJTableViewVMTextFieldRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMTextFieldCell : DJTableViewVMCell<UITextFieldDelegate>

@property (nonatomic, strong) DJTableViewVMTextFieldRow *rowVM;
@property (nonatomic, readonly) UITextField *textField;

- (void)textFieldDidChange:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END
