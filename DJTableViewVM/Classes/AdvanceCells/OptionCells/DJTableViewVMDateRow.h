//
//  DJTableViewVMDateRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRow.h"
#import "DJTableViewVMChooseBaseRow.h"

@interface DJTableViewVMDateRow : DJTableViewVMChooseBaseRow

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSString *dateFormat;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic, copy) NSAttributedString *attributedPlaceholder;//default is nil
@property(nonatomic, strong) UIColor *pickerBackgroundColor;
@property(nonatomic, strong) UIColor *pickerTitleColor;

@property(nonatomic, assign) UIDatePickerMode datePickerMode;
@property(nonatomic, strong) NSLocale *locale;                // default is [NSLocale currentLocale]. setting nil returns to default
@property(nonatomic, strong) NSCalendar *calendar;              // default is [NSCalendar currentCalendar]. setting nil returns to default
@property(nonatomic, strong) NSTimeZone *timeZone;              // default is nil. use current time zone or time zone from calendar
@property(nonatomic, strong) NSDate *minimumDate;           // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property(nonatomic, strong) NSDate *maximumDate;           // default is nil
@property(nonatomic, assign) NSTimeInterval countDownDuration; // for UIDatePickerModeCountDownTimer, ignored otherwise. default is 0.0. limit is 23:59 (86,399 seconds). value being set is div 60 (drops remaining seconds).
@property(nonatomic, assign) NSInteger minuteInterval;        // display minutes wheel with interval. interval must be evenly divided into 60. default is 1. min is 1, max is 30

@property(nonatomic, copy) void(^dateValueChangedHandler)(DJTableViewVMDateRow *row);

- (id)initWithTitle:(NSString *)title date:(NSDate *)date placeholder:(NSString *)placeholder format:(NSString *)dateFormat datePickerMode:(UIDatePickerMode)datePickerMode;

@end
