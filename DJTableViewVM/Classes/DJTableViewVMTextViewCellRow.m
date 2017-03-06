//
//  DJTableViewVMTextViewCellRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextViewCellRow.h"
#import "DJToolBar.h"

#define MagicMarginNumber DJTableViewVMTextViewCellRowMagicMarginNumber

@implementation DJTableViewVMTextViewCellRow
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
        isEditable = YES;
        _textContainerInset = UIEdgeInsetsMake(MagicMarginNumber, -MagicMarginNumber, MagicMarginNumber, 0);
        self.cellHeight = 128;
    }
    return self;
}

@end
