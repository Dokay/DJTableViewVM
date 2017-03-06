//
//  DJToolBar.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/6.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJToolBar.h"

@interface DJToolBar()

@property(nonatomic, strong) UIButton *preButton;
@property(nonatomic, strong) UIButton *nextButton;
@property(nonatomic, strong) UIButton *doneButton;
@property(nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation DJToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupCurrentView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupCurrentView];
}

- (void)setupCurrentView
{
    [self addSubview:self.preButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.doneButton];
    [self addSubview:self.palceholderLabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_preButton,_nextButton,_doneButton,_placeholderLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_preButton]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nextButton]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_doneButton]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_placeholderLabel]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_preButton(12)]-25-[_nextButton(12)][_placeholderLabel(>=0@700)][_doneButton(>=0)]-20-|" options:0 metrics:nil views:views]];
    
    self.nextButton.enabled = self.nextEnable;
    self.preButton.enabled  = self.preEnable;
}

- (void)onTouchButton:(UIButton *)button
{
    if (button == self.preButton) {
        if (self.tapPreHandler) {
            self.tapPreHandler();
        }
    }
    
    if (button == self.nextButton) {
        if (self.tapNextHandler) {
            self.tapNextHandler();
        }
    }
    
    if (button == self.doneButton) {
        if (self.tapDoneHandler) {
            self.tapDoneHandler();
        }
    }
}

#pragma mark - seter
- (void)setDoneTitle:(NSString *)doneTitle
{
    _doneTitle = doneTitle;
    [self.doneButton setTitle:doneTitle forState:UIControlStateNormal];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPreEnable:(BOOL)preEnable
{
    _preEnable = preEnable;
    self.preButton.enabled = preEnable;
}

- (void)setNextEnable:(BOOL)nextEnable
{
    _nextEnable = nextEnable;
    self.nextButton.enabled = nextEnable;
}

#pragma mark - getter
- (UIButton *)preButton
{
    if (_preButton == nil) {
        _preButton = [UIButton new];
        _preButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_preButton addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *image = [UIImage imageNamed:@"DJArrowLeft"];
        [_preButton setImage:image forState:UIControlStateNormal];
    }
    return _preButton;
}

- (UIButton *)nextButton
{
    if (_nextButton == nil) {
        _nextButton = [UIButton new];
        _nextButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_nextButton addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage imageNamed:@"DJArrowRight"];
        [_nextButton setImage:image forState:UIControlStateNormal];
    }
    return _nextButton;
}

- (UIButton *)doneButton
{
    if (_doneButton == nil) {
        _doneButton = [UIButton new];
        _doneButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UILabel *)palceholderLabel
{
    if (_placeholderLabel == nil) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _placeholderLabel.text = @"pal";
        _placeholderLabel.textAlignment = NSTextAlignmentCenter;
        _placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    return _placeholderLabel;
}

@end
