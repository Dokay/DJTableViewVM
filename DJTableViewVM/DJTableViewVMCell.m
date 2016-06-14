//
//  DJComponentTableViewVMCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMCell.h"

@interface DJTableViewVMCell()

@property (nonatomic, weak) UIView *separatorLineView;

@end

@implementation DJTableViewVMCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

+ (CGFloat)heightWithRow:(DJTableViewVMRow *)row tableViewVM:(DJTableViewVM *)tableViewVM
{
    if ([row isKindOfClass:[DJTableViewVMRow class]] && row.cellHeight > 0){
        return row.cellHeight;
    }else{
        return 44.0f;
    }
}

#pragma mark Cell life cycle
- (void)cellDidLoad
{
    
}

- (void)cellWillAppear
{
    DJTableViewVMRow *row = self.rowVM;
    
    self.selectionStyle  = row.selectionStyle;
    self.backgroundColor = row.backgroundColor;
    self.textLabel.text  = row.title;
    self.accessoryType   = row.accessoryType;
    self.accessoryView   = row.accessoryView;
    self.imageView.image = row.image;
    self.textLabel.textAlignment    = row.textAlignment;
    self.textLabel.backgroundColor  = [UIColor clearColor];
    self.imageView.highlightedImage = row.highlightedImage;
    self.textLabel.font             = row.titleFont;
    self.textLabel.textColor        = row.titleColor;
    self.detailTextLabel.font       = row.detailTitleFont;
    self.detailTextLabel.textColor  = row.titleColor;
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
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.rowVM isKindOfClass:[DJTableViewVMRow class]]) {
        switch (self.rowVM.separatorLineType) {
            case DJCellSeparatorLineDefault:
            {
                
            }
                break;
            case DJCellSeparatorLineHide:
            {
                self.separatorLineView.hidden = YES;
            }
                break;
            case DJCellSeparatorLineShow:
            {
                self.separatorLineView.hidden = NO;
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - private method

#pragma mark - getter
- (UIView *)separatorLineView
{
    if (_separatorLineView == nil) {
        for (UIView *subview in self.contentView.superview.subviews) {
            if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
                _separatorLineView = subview;
            }
        }
    }
    return _separatorLineView;
}
@end
