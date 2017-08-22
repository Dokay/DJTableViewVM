//
//  DJTableViewVMBoolCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMBoolCell.h"

@implementation DJTableViewVMBoolCell
@dynamic rowVM;


- (void)cellDidLoad
{
    [super cellDidLoad];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.switchView];
    
    NSDictionary *metrics = @{@"rightMargin": @(self.rowVM.elementEdge.right)};
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.switchView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_switchView]-rightMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_switchView)]];
}

- (void)cellWillAppear
{
    self.textLabel.text = self.rowVM.title;
    self.switchView.on = self.rowVM.value;
    self.switchView.enabled = self.rowVM.enabled;
    self.userInteractionEnabled = self.rowVM.enabled;
}

- (void)valueDidChanged:(UISwitch *)sender
{
    self.rowVM.value = sender.isOn;
    if (self.rowVM.valueChangeBlock) {
        self.rowVM.valueChangeBlock(self.rowVM);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.textLabel.frame.origin.x + self.textLabel.frame.size.width >= self.switchView.frame.origin.x){
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.frame.size.width - self.textLabel.frame.origin.x - self.switchView.frame.size.width - 10.0 - self.rowVM.elementEdge.right, self.textLabel.frame.size.height);
    }
    
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

#pragma mark - getter
- (UISwitch *)switchView
{
    if (_switchView == nil) {
        _switchView = [[UISwitch alloc] init];
        _switchView.translatesAutoresizingMaskIntoConstraints = NO;
        [_switchView addTarget:self action:@selector(valueDidChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchView;
}

@end
