//
//  DJMultipleLineTextCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJMultipleLineTextCell.h"

@interface DJMultipleLineTextCell()

@property (nonatomic, strong) UILabel *multipleLinesLabel;

@end

@implementation DJMultipleLineTextCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    [self.contentView addSubview:self.multipleLinesLabel];
    
    NSDictionary *metrics=@{@"leftMargin":@(self.rowVM.elementEdge.left),
                            @"topMargin":@(self.rowVM.elementEdge.top),
                            @"rightMargin":@(self.rowVM.elementEdge.right),
                            @"bottomMargin":@(self.rowVM.elementEdge.bottom),};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topMargin-[_multipleLinesLabel]-bottomMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_multipleLinesLabel)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[_multipleLinesLabel]-rightMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_multipleLinesLabel)]];
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
