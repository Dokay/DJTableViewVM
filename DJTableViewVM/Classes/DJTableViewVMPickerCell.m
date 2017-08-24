//
//  DJTableViewVMPickerCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMPickerCell.h"
#import "DJNormalPickerDelegate.h"

@interface DJTableViewVMPickerCell()


@end

@implementation DJTableViewVMPickerCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    self.textField.inputView = self.pickerView;
    
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    
    self.pickerView.delegate = self.rowVM.pickerDelegate;
    self.pickerView.dataSource = self.rowVM.pickerDelegate;
    self.rowVM.pickerDelegate.pickerView = self.pickerView;
    __weak typeof(self) weakSelf = self;
    [self.rowVM.pickerDelegate setValueChangeBlock:^(NSArray *valuesArray){
        [weakSelf updateCurrentValue:valuesArray];
    }];
    
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.text = self.rowVM.placeholder;
    if (self.rowVM.attributedPlaceholder) {
        self.placeholderLabel.attributedText = self.rowVM.attributedPlaceholder;
    }
    if (self.rowVM.toolbarTintColor) {
        self.accessoryView.tintColor = self.rowVM.toolbarTintColor;
    }
    
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
    
}

- (void)updateCurrentValue:(NSArray *)valuesArray
{
    self.rowVM.valueArray = [valuesArray copy];
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
    
    if (self.rowVM.onValueChangeHandler) {
        self.rowVM.onValueChangeHandler(self.rowVM);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.rowVM.pickerDelegate setSelectedWithValue:self.rowVM.valueArray];
    }
}

#pragma mark - getter
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectNull];
    }
    return _pickerView;
}

@end
