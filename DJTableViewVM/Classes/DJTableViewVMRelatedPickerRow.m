//
//  DJTableViewVMRelatedPickerRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRelatedPickerRow.h"

@implementation DJTableViewVMRelatedPickerRow

- (NSArray<NSNumber *> *)selectIndexArray
{
    return nil;
}

- (id)initWithTitle:(NSString *)title value:(NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder relatedPptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)relatedOptionsArray
{
    self = [super init];
    if (self) {
        self.title = title;
        self.style = UITableViewCellStyleValue1;
        self.elementEdge = UIEdgeInsetsMake(self.elementEdge.top, self.elementEdge.left, self.elementEdge.bottom, 0);
        _valueArray = valueArray;
        _placeholder = placeholder;
        _relatedOptionsArray = relatedOptionsArray;
        _focusScrollPosition = UITableViewScrollPositionBottom;
    }
    return self;
}

@end
