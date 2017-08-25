//
//  DJTableViewVMChooseBaseCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMChooseBaseCell.h"

@interface DJTableViewVMChooseBaseCell()<UITextFieldDelegate>

@end

@implementation DJTableViewVMChooseBaseCell
@dynamic rowVM;

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.placeholderLabel];
    
    NSDictionary *metrics = @{@"leftMargin":@(self.rowVM.elementEdge.left),
                              @"topMargin":@(self.rowVM.elementEdge.top),
                              @"rightMargin":@(self.rowVM.elementEdge.right),
                              @"bottomMargin":@(self.rowVM.elementEdge.bottom),};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_placeholderLabel(>=20)]-rightMargin-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(_placeholderLabel)]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1.0
                                                                  constant:0]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textField]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_textField)]];

}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.text = self.rowVM.title.length == 0 ? @" " : self.rowVM.title;
    
    self.userInteractionEnabled = self.rowVM.enabled;
    self.textField.enabled = self.rowVM.enabled;
    
    self.detailTextLabel.userInteractionEnabled = NO;
    self.textLabel.userInteractionEnabled = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.textField becomeFirstResponder];
    }
}

- (BOOL)resignFirstResponder
{
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder
{
    [self.textField becomeFirstResponder];
    return [super becomeFirstResponder];
}

- (UIResponder *)responder
{
    return self.textField;
}

#pragma mark - overwrite
- (void)updateWithValue:(NSObject *)newValue
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.selected){
        [self setSelected:YES animated:NO];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self setSelected:NO animated:NO];
    [self.rowVM deselectRowAnimated:NO];
    return YES;
}

#pragma mark - getter
- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectNull];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.alpha = 0.0f;
        _textField.inputAccessoryView = self.inputAccessoryView;
        _textField.delegate = self;
        _textField.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _textField;
}

- (DJToolBar *)inputAccessoryView
{
    if (_inputAccessoryView == nil) {
        _inputAccessoryView = [DJToolBar new];
    }
    return _inputAccessoryView;
}

- (UILabel *)placeholderLabel
{
    if (_placeholderLabel == nil) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        _placeholderLabel.font = self.rowVM.detailTitleFont;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.userInteractionEnabled = NO;
        _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _placeholderLabel;
}

@end
