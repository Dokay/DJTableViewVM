//
//  DJTableViewVMSegmentedCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMSegmentedCell.h"

@interface DJTableViewVMSegmentedCell()

@property(nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation DJTableViewVMSegmentedCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.segmentedControl];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.text = self.rowVM.title;
    [self.segmentedControl removeAllSegments];
   
    if (self.rowVM.segmentedTitles.count > 0) {
        [self.rowVM.segmentedTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
            [self.segmentedControl insertSegmentWithTitle:title atIndex:idx animated:NO];
        }];
    } else if (self.rowVM.segmentedImages.count > 0) {
        [self.rowVM.segmentedImages enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
            [self.segmentedControl insertSegmentWithImage:image atIndex:idx animated:NO];
        }];
    }
    self.segmentedControl.selectedSegmentIndex = self.rowVM.selectIndex;
    self.segmentedControl.tintColor = self.rowVM.tintColor;
    self.userInteractionEnabled = self.rowVM.enabled;
    self.segmentedControl.enabled = self.rowVM.enabled;
    
    [self.segmentedControl.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.segmentedControl removeConstraint:obj];
    }];
    
    [self addConstrantToSegmentedControl];
    [self.segmentedControl setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.textLabel.frame.size.width - self.segmentedControl.frame.size.width - 10.0, self.textLabel.frame.size.height);
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

- (void)addConstrantToSegmentedControl
{
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.segmentedControl
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_segmentedControl(==30)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentedControl)]];
    
    NSDictionary *metrics=@{@"leftMargin":@(self.rowVM.elementEdge.left),
                            @"topMargin":@(self.rowVM.elementEdge.top),
                            @"rightMargin":@(self.rowVM.elementEdge.right),
                            @"bottomMargin":@(self.rowVM.elementEdge.bottom),};
    
    if (self.rowVM.title.length > 0) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_segmentedControl(>=140)]-rightMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_segmentedControl)]];
    } else {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftMargin-[_segmentedControl]-rightMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_segmentedControl)]];
    }
}

#pragma mark - events
- (void)segmentValueDidChange:(UISegmentedControl *)segmentedControlView
{
    self.rowVM.selectIndex = segmentedControlView.selectedSegmentIndex;
    if (self.rowVM.indexValueChangeHandler){
        self.rowVM.indexValueChangeHandler(self.rowVM);
    }
}

#pragma mark - getter
- (UISegmentedControl *)segmentedControl
{
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectNull];
        _segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        [_segmentedControl addTarget:self action:@selector(segmentValueDidChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end
