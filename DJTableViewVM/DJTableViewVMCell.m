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
    self.indentationLevel = row.indentationLevel;
    self.indentationWidth = row.indentationWidth;
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
}

- (void)cellDidDisappear
{
    //to be overwrite
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self refreshCurrentSeparatorLine];
    [self refreshIndentationWidth];
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

- (void)refreshIndentationWidth
{
    float indentSize = self.indentationLevel * self.indentationWidth;
    
    if (indentSize > 0) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            view.frame = CGRectMake(view.frame.origin.x+indentSize,view.frame.origin.y,view.frame.size.width,view.frame.size.height);
        }];
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
