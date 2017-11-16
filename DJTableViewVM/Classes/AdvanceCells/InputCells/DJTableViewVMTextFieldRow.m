//
//  DJTableViewVMTextFieldRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextFieldRow.h"
#import "DJToolBar.h"

@implementation DJTableViewVMTextFieldRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        _charactersMaxCount = 0;
        _textFiledLeftMargin = 0;
        _font = self.titleFont;
        _textColor = self.titleColor;
        _autocapitalizationType = UITextAutocapitalizationTypeSentences;
        _minimumFontSize = 0.0f;
        _clearButtonMode = UITextFieldViewModeNever;
        _focusScrollPosition = UITableViewScrollPositionBottom;
        _showInputAccessoryView = YES;
        _inputAccessoryView = [DJToolBar new];
        self.enabled = YES;
    }
    return self;
}

@end
