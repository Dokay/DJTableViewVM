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

@property (nonatomic, strong) NSArray *separatorLineViews;

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
    self.detailTextLabel.font       = row.detailTextFont;
    self.detailTextLabel.textColor  = row.detailTextColor;
    self.detailTextLabel.text       = row.detailText;
    
    if (row.titleAttributedString != nil) {
        self.textLabel.attributedText = row.titleAttributedString;
    }
    
    if (row.detailAttributedString != nil) {
        self.detailTextLabel.attributedText = row.detailAttributedString;
    }
    
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

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image == nil) {
        DJRectSetLeft(self.textLabel,self.rowVM.elementEdge.left);
        DJRectSetRight(self.detailTextLabel,self.rowVM.elementEdge.right);
    }else{
        DJRectSetLeft(self.imageView,self.rowVM.elementEdge.left);
        DJRectSetLeft(self.textLabel,self.rowVM.elementEdge.left + self.imageView.frame.size.width + 15);
        DJRectSetRight(self.detailTextLabel,self.rowVM.elementEdge.right);
    }
    
    [self refreshCurrentSeparatorLine];
}

#pragma mark - private method
- (void)refreshCurrentSeparatorLine
{
    if ([self.rowVM isKindOfClass:[DJTableViewVMRow class]]) {
        switch (self.rowVM.separatorLineType) {
            case DJCellSeparatorLineDefault:
            {
                //do nothing
            }
                break;
            case DJCellSeparatorLineHide:
            {
                [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull separatorLineView, NSUInteger idx, BOOL * _Nonnull stop) {
                    separatorLineView.hidden = YES;
                    separatorLineView.alpha = 0.0f;
                }];
            }
                break;
            case DJCellSeparatorLineShow:
            {
                [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull separatorLineView, NSUInteger idx, BOOL * _Nonnull stop) {
                    separatorLineView.hidden = NO;
                    separatorLineView.alpha = 1.0f;
                }];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - getter
- (NSArray *)separatorLineViews
{
    if (_separatorLineViews == nil) {
        //unsafe method to get SeparatorView.apple may change class name for _UITableViewCellSeparatorView
        NSMutableArray *tmpViews = [NSMutableArray new];
        for (UIView *subview in self.contentView.superview.subviews) {
            if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
                [tmpViews addObject:subview];
            }
        }
        _separatorLineViews = tmpViews.copy;
    }
    return _separatorLineViews;
}
@end
