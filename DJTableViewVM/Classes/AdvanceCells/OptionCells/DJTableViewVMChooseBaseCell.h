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

#define DJInputViewHeight 216 //default height must set in iOS 11,if CGRectNull will crash for "'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan -inf]'"

@interface DJTableViewVMChooseBaseCell : DJTableViewVMCell

@property(nonatomic, strong) DJTableViewVMRow *rowVM;

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) DJToolBar *inputAccessoryView;
@property(nonatomic, strong) UILabel *placeholderLabel;

- (void)updateWithValue:(NSObject *)newValue;

@end
