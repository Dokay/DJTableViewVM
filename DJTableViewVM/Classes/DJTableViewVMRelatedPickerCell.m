//
//  DJTableViewVMRelatedPickerCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRelatedPickerCell.h"
#import "DJRelatedPickerDelegate.h"
@interface DJTableViewVMRelatedPickerCell()

@property(nonatomic, strong) DJRelatedPickerDelegate *relatedPickerDelegate;

@end

@implementation DJTableViewVMRelatedPickerCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    self.textField.inputView = self.pickerView;
    
    self.pickerView.delegate = self.relatedPickerDelegate;
    self.pickerView.dataSource = self.relatedPickerDelegate;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
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
        [self.relatedPickerDelegate setSelectedWithValue:self.rowVM.valueArray];
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

- (DJRelatedPickerDelegate *)relatedPickerDelegate
{
    if (_relatedPickerDelegate == nil) {
        _relatedPickerDelegate = [[DJRelatedPickerDelegate alloc] initWithOptions:self.rowVM.relatedOptionsArray pickerView:self.pickerView];
        
        __weak typeof(self) weakSelf = self;
        [_relatedPickerDelegate setValueChangeBlock:^(NSArray *valuesArray){
            [weakSelf updateCurrentValue:valuesArray];
        }];
    }
    return _relatedPickerDelegate;
}

@end
