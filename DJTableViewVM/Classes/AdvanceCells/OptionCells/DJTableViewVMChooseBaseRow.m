//
//  DJTableViewVMChooseBaseRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/11/17.
//Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMChooseBaseRow.h"
#import "DJToolBar.h"

@implementation DJTableViewVMChooseBaseRow

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _showInputAccessoryView = YES;
        _inputAccessoryView = [DJToolBar new];
    }
    return self;
}

@end
