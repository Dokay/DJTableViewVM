//
//  DJTableViewVMBoolRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMBoolRow.h"

@implementation DJTableViewVMBoolRow

- (instancetype)initWithTitle:(NSString *)aTitle value:(BOOL)aValue valueChangeHander:(switchValueChangeBlock)valueChangeBlock
{
    self = [super init];
    if (self) {
        _valueChangeBlock = valueChangeBlock;
        _value = aValue;
        _enabled = YES;
        self.title = aTitle;
    }
    
    return self;
}

@end
