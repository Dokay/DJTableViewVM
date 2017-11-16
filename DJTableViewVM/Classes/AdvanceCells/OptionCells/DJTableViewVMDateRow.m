//
//  DJTableViewVMDateRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMDateRow.h"
#import "DJToolBar.h"

@implementation DJTableViewVMDateRow

- (id)initWithTitle:(NSString *)title date:(NSDate *)date placeholder:(NSString *)placeholder format:(NSString *)dateFormat datePickerMode:(UIDatePickerMode)datePickerMode
{
    self = [super init];
    if (self) {
        self.title = title;
        self.style = UITableViewCellStyleValue1;
        self.elementEdge = UIEdgeInsetsMake(self.elementEdge.top, self.elementEdge.left, self.elementEdge.bottom, 0);
        _date = date;
        _placeholder = placeholder;
        _dateFormat = dateFormat;
        _datePickerMode = datePickerMode;
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _showInputAccessoryView = YES;
        _inputAccessoryView = [DJToolBar new];
    }
    return self;
}

@end
