//
//  DJTableViewVMPickerCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMPickerCell.h"
#import "DJToolBar.h"

@interface DJTableViewVMPickerCell()<UIPickerViewDelegate,UIPickerViewDataSource>



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

- (void)updateCurrentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    [self.rowVM.optionsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *options = [self.rowVM.optionsArray objectAtIndex:idx];
        NSString *valueText = [options objectAtIndex:[self.pickerView selectedRowInComponent:idx]];
        [valuesArray addObject:valueText];
    }];
    self.rowVM.valueArray = [valuesArray copy];
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.rowVM.valueArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.rowVM.optionsArray.count > idx) {
                NSArray *componentArray = self.rowVM.optionsArray[idx];
                NSInteger destRow = [componentArray indexOfObject:valueElement];
                [self.pickerView selectRow:destRow inComponent:idx animated:NO];
            }
        }];
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.rowVM.optionsArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray<NSString *> *titlesArray = [self.rowVM.optionsArray objectAtIndex:component];
    NSAssert([titlesArray isKindOfClass:[NSArray class]], @"elements of optionsArray is also array");
    return [titlesArray count];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray<NSString *> *titlesArray = [self.rowVM.optionsArray objectAtIndex:component];
    return [titlesArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateCurrentValue];
    if (self.rowVM.onValueChangeHandler){
        self.rowVM.onValueChangeHandler(self.rowVM);
    }
    
    [pickerView reloadAllComponents];
    [self updateCurrentValue];
    
}

#pragma mark - getter
- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectNull];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

@end
