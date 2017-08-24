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

@property(nonatomic, strong) DJNormalPickerDelegate *normalPickerDelegate;

@end

@implementation DJTableViewVMPickerCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    self.textField.inputView = self.pickerView;
    self.pickerView.delegate = self.normalPickerDelegate;
    self.pickerView.dataSource = self.normalPickerDelegate;
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
//    NSMutableArray *valuesArray = [NSMutableArray array];
//    
//    [self.rowVM.optionsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSArray *options = [self.rowVM.optionsArray objectAtIndex:idx];
//        NSString *valueText = [options objectAtIndex:[self.pickerView selectedRowInComponent:idx]];
//        [valuesArray addObject:valueText];
//    }];
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
//        [self.rowVM.valueArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (self.rowVM.optionsArray.count > idx) {
//                NSArray *componentArray = self.rowVM.optionsArray[idx];
//                NSInteger destRow = [componentArray indexOfObject:valueElement];
//                [self.pickerView selectRow:destRow inComponent:idx animated:NO];
//            }
//        }];
        [self.normalPickerDelegate setSelectedWithValue:self.rowVM.valueArray];
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

- (DJNormalPickerDelegate *)normalPickerDelegate
{
    if (_normalPickerDelegate == nil) {
        _normalPickerDelegate = [[DJNormalPickerDelegate alloc] initWithOptions:self.rowVM.optionsArray pickerView:self.pickerView];
        
        __weak typeof(self) weakSelf = self;
        [_normalPickerDelegate setValueChangeBlock:^(NSArray *valuesArray){
            [weakSelf updateCurrentValue:valuesArray];
        }];
    }
    return _normalPickerDelegate;
}

@end
