//
//  DJTableViewVMTextFieldCellRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextFieldCellRow.h"
#import "DJToolBar.h"

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
        
        DJToolBar *toolBarView = [DJToolBar new];
        toolBarView.frame = CGRectMake(0, 0, [UIApplication sharedApplication].keyWindow.bounds.size.width, 44);
        _inputAccessoryView = toolBarView;
    }
    return self;
}

@end
