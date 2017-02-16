//
//  DJComponentTableViewVMCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMCell.h"
#import "DJTableViewVM.h"

@interface DJTableViewVMCell()

@property (nonatomic, weak) UIView *separatorLineView;

@end

@implementation DJTableViewVMCell

+ (CGFloat)heightWithRow:(DJTableViewVMRow *)row tableViewVM:(DJTableViewVM *)tableViewVM
{
    if ([row isKindOfClass:[DJTableViewVMRow class]] && row.cellHeight > 0){
        return row.cellHeight;
    }else{
        return tableViewVM.rowHeight > 0.0f ? tableViewVM.rowHeight : 44.0f;
    }
}

#pragma mark Cell life cycle
- (void)cellDidLoad
{
    self.loaded = YES;
}

- (void)cellWillAppear
{
    DJTableViewVMRow *row = self.rowVM;
    
    self.selectionStyle  = row.selectionStyle;
    self.accessoryType   = row.accessoryType;
    self.backgroundColor = row.backgroundColor;
    self.accessoryView   = row.accessoryView;
    self.imageView.image = row.image;
    self.imageView.highlightedImage = row.highlightedImage;
    self.textLabel.textAlignment    = row.titleTextAlignment;
    self.textLabel.backgroundColor  = [UIColor clearColor];
    self.textLabel.text             = row.title;
    self.textLabel.font             = row.titleFont;
    self.textLabel.textColor        = row.titleColor;
    self.detailTextLabel.font       = row.detailTitleFont;
    self.detailTextLabel.textColor  = row.detailTitleColor;
    self.detailTextLabel.text       = row.detailText;
    
    if (row.separatorInset.top != CGFLOAT_MAX) {
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            [self setSeparatorInset:row.separatorInset];
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            [self setLayoutMargins:row.separatorInset];
        }
        if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            [self setPreservesSuperviewLayoutMargins:NO];
        }
    }
    
    self.indentationWidth = 10;
    self.indentationLevel = 10;
}

- (void)cellDidDisappear
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self refreshCurrentSeparatorLine];
}

#pragma mark - private method
- (void)refreshCurrentSeparatorLine
{
    if ([self.rowVM isKindOfClass:[DJTableViewVMRow class]]) {
        switch (self.rowVM.separatorLineType) {
            case DJCellSeparatorLineDefault:
            {
                _separatorLineView.alpha = 1.0f;//line maybe has changed
            }
                break;
            case DJCellSeparatorLineHide:
            {
                self.separatorLineView.alpha = 0.0f;
            }
                break;
            case DJCellSeparatorLineShow:
            {
                self.separatorLineView.alpha = 1.0f;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - getter
- (UIView *)separatorLineView
{
    if (_separatorLineView == nil) {
        //unsafe method to get SeparatorView.apple may change class name for _UITableViewCellSeparatorView
        for (UIView *subview in self.contentView.superview.subviews) {
            if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
                _separatorLineView = subview;
            }
        }
    }
    return _separatorLineView;
}
@end
