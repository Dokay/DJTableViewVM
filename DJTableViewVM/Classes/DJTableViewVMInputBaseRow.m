//
//  DJTableViewVMInputBaseRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/6.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMInputBaseRow.h"
#import "DJToolBar.h"

@implementation DJTableViewVMInputBaseRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        _enabled = YES;
        _editing = NO;
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _inputAccessoryView = [DJToolBar new];
    }
    return self;
}

- (void)setToolbarTintColor:(UIColor *)toolbarTintColor
{
    _toolbarTintColor = toolbarTintColor;
    if ([self.inputAccessoryView isKindOfClass:[DJToolBar class]]) {
        ((DJToolBar *)self.inputAccessoryView).tintColor = toolbarTintColor;
    }
}


@end
