//
//  DJTableViewVMTextViewRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextViewRow.h"
#import "DJToolBar.h"

#define MagicMarginNumber DJTableViewVMTextViewRowMagicMarginNumber

@implementation DJTableViewVMTextViewRow
@synthesize enabled = isEditable;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _placeholderFont = self.titleFont;
        _placeholderColor = [UIColor lightGrayColor];
        _charactersCountFont = [UIFont systemFontOfSize:13];
        _charactersCountColor = [UIColor lightGrayColor];
        _selectable = YES;
        _font = self.titleFont;
        _textColor = self.titleColor;
        _editable = YES;
        _textContainerInset = UIEdgeInsetsMake(MagicMarginNumber, -MagicMarginNumber, MagicMarginNumber, 0);
        self.cellHeight = 128;
        isEditable = YES;
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _showInputAccessoryView = YES;
        _inputAccessoryView = [DJToolBar new];
    }
    return self;
}

@end
