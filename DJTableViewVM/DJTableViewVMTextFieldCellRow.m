//
//  DJTableViewVMTextFieldCellRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextFieldCellRow.h"

@implementation DJTableViewVMTextFieldCellRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        _charactersMaxCount = 0;
        _textFiledLeftMargin = 0;
        _enabled = YES;
        _font = self.titleFont;
        _textColor = self.titleColor;
        _autocapitalizationType = UITextAutocapitalizationTypeSentences;
        _minimumFontSize = 0.0f;
        _clearButtonMode = UITextFieldViewModeNever;
        _focusScrollPosition = UITableViewScrollPositionBottom;
    }
    return self;
}

@end
