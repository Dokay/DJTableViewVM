//
//  DJTableViewVMLinesTextCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMLinesTextCell.h"

@interface DJTableViewVMLinesTextCell()

@property (nonatomic, strong) UILabel *multipleLinesLabel;

@end

@implementation DJTableViewVMLinesTextCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    [self.contentView addSubview:self.multipleLinesLabel];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.textLabel.text = @"";
    
    self.multipleLinesLabel.text = self.rowVM.text;
    self.multipleLinesLabel.numberOfLines = self.rowVM.numberOfLines;
    self.multipleLinesLabel.font = self.rowVM.titleFont;
    self.multipleLinesLabel.textColor = self.rowVM.titleColor;
    self.multipleLinesLabel.textAlignment = self.rowVM.titleTextAlignment;
    self.multipleLinesLabel.lineBreakMode = self.rowVM.lineBreakMode;
    
    [self updateLabelLayout];
}

- (void)updateLabelLayout
{
    [self.multipleLinesLabel.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView removeConstraint:obj];
    }];
    
    NSDictionary *metrics=@{@"leftMargin":@(self.rowVM.elementEdge.left),
                            @"topMargin":@(self.rowVM.elementEdge.top),
                            @"rightMargin":@(self.rowVM.elementEdge.right),
                            @"bottomMargin":@(self.rowVM.elementEdge.bottom),};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[_multipleLinesLabel]-bottomMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_multipleLinesLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[_multipleLinesLabel]-rightMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_multipleLinesLabel)]];
}

#pragma mark - getter
- (UILabel *)multipleLinesLabel
{
    if (_multipleLinesLabel == nil) {
        _multipleLinesLabel = [UILabel new];
        _multipleLinesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _multipleLinesLabel;
}

@end
