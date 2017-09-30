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

@property(nonatomic, strong) UIPickerView *pickerView;

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
    
    self.pickerView.backgroundColor = self.rowVM.pickerBackgroundColor;
    self.pickerView.showsSelectionIndicator = self.rowVM.showsSelectionIndicator;
    self.pickerView.delegate = self.rowVM.pickerDelegate;
    self.pickerView.dataSource = self.rowVM.pickerDelegate;
    self.rowVM.pickerDelegate.pickerView = self.pickerView;
    __weak typeof(self) weakSelf = self;
    [self.rowVM.pickerDelegate setValueChangeBlock:^(NSArray<NSString *> *valuesArray){
        [weakSelf updateWithValue:valuesArray];
    }];
    
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.text = self.rowVM.placeholder;
    if (self.rowVM.attributedPlaceholder) {
        self.placeholderLabel.attributedText = self.rowVM.attributedPlaceholder;
    }
    if (self.rowVM.toolbarTintColor) {
        self.textField.inputAccessoryView.tintColor = self.rowVM.toolbarTintColor;
    }
    
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
    
}

- (void)updateWithValue:(NSArray<NSString *> *)valuesArray
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
        [self.rowVM.pickerDelegate refreshPickerWithValues:self.rowVM.valueArray];
    }
}

#pragma mark - getter
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _pickerView;
}

@end
