//
//  DJTableViewVMDateCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMDateCell.h"

@interface DJTableViewVMDateCell()

@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DJTableViewVMDateCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    self.textField.inputView = self.datePicker;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.placeholderLabel.text = self.rowVM.placeholder;
    if (self.rowVM.attributedPlaceholder) {
        self.placeholderLabel.attributedText = self.rowVM.attributedPlaceholder;
    }
    if (self.rowVM.toolbarTintColor) {
        self.textField.inputAccessoryView.tintColor = self.rowVM.toolbarTintColor;
    }
    
    self.datePicker.backgroundColor = self.rowVM.pickerBackgroundColor;
    self.datePicker.date = self.rowVM.date ? self.rowVM.date : (self.rowVM.startDate ? self.rowVM.startDate : [NSDate date]);
    if (self.datePicker.datePickerMode != self.rowVM.datePickerMode) {
        self.datePicker.datePickerMode = self.rowVM.datePickerMode;
    }
    
    if (self.rowVM.locale) {
        self.datePicker.locale = self.rowVM.locale;
    }
    if (self.rowVM.calendar) {
        self.datePicker.calendar = self.rowVM.calendar;
    }
    if (self.rowVM.timeZone) {
        self.datePicker.timeZone = self.rowVM.timeZone;
    }
    
    if (self.datePicker.minimumDate != self.rowVM.minimumDate) {
        self.datePicker.minimumDate = self.rowVM.minimumDate;
    }
    if (self.datePicker.maximumDate != self.rowVM.maximumDate) {
        self.datePicker.maximumDate = self.rowVM.maximumDate;
    }
    if (self.datePicker.minuteInterval != self.rowVM.minuteInterval) {
        self.datePicker.minuteInterval = self.rowVM.minuteInterval;
    }
    if (self.datePicker.countDownDuration != self.rowVM.countDownDuration) {
        self.datePicker.countDownDuration = self.rowVM.countDownDuration;
    }

    self.detailTextLabel.text = self.rowVM.date ? [self.dateFormatter stringFromDate:self.rowVM.date] : @"请选择";
    self.placeholderLabel.text = self.rowVM.placeholder;
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
    
    if (!self.rowVM.title) {
        self.detailTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    self.userInteractionEnabled = self.rowVM.enabled;
    self.datePicker.enabled = self.rowVM.enabled;
}

- (void)updateWithValue:(NSDate *)newValue
{
    self.rowVM.date = newValue;
    self.detailTextLabel.text = [self.dateFormatter stringFromDate:self.rowVM.date];
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
}

#pragma mark - events
- (void)onDateValueChanged:(UIPickerView *)datePicker
{
    [self updateWithValue:self.datePicker.date];
   
    if (self.rowVM.dateValueChangedHandler) {
        self.rowVM.dateValueChangedHandler(self.rowVM);
    }
}

#pragma mark - getter
- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), DJInputViewHeight)];
        [_datePicker addTarget:self action:@selector(onDateValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (NSDateFormatter *)dateFormatter
{
    BOOL formatChanged = _dateFormatter.dateFormat != self.rowVM.dateFormat
                        || _dateFormatter.calendar != self.rowVM.calendar
                        || _dateFormatter.timeZone != self.rowVM.timeZone
                        || _dateFormatter.locale != self.rowVM.locale;
    if (_dateFormatter == nil || formatChanged) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = self.rowVM.dateFormat;
        _dateFormatter.calendar = self.rowVM.calendar;
        _dateFormatter.timeZone = self.rowVM.timeZone;
        _dateFormatter.locale = self.rowVM.locale;
    }
    return _dateFormatter;
}

@end
