//
//  DJTableViewVMPickerCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMPickerCell.h"
#import "DJToolBar.h"

@interface DJTableViewVMPickerCell()<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) DJToolBar *inputAccessoryView;
@property(nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation DJTableViewVMPickerCell
@dynamic rowVM;

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

- (UIResponder *)responder
{
    return self.textField;
}

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
    
    self.textField.inputView = self.pickerView;
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.textLabel.text = self.rowVM.title.length == 0 ? @" " : self.rowVM.title;
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.text = self.rowVM.placeholder;
    if (self.rowVM.attributedPlaceholder) {
        self.placeholderLabel.attributedText = self.rowVM.attributedPlaceholder;
    }
    
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
    
    self.userInteractionEnabled = self.rowVM.enabled;
    self.textField.enabled = self.rowVM.enabled;
    
    self.detailTextLabel.userInteractionEnabled = NO;
    self.textLabel.userInteractionEnabled = NO;
}

- (void)updateCurrentValue
{
    NSMutableArray *valuesArray = [NSMutableArray array];
    
    [self.rowVM.optionsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *options = [self.rowVM.optionsArray objectAtIndex:idx];
        NSString *valueText = [options objectAtIndex:[self.pickerView selectedRowInComponent:idx]];
        [valuesArray addObject:valueText];
    }];
    self.rowVM.valueArray = [valuesArray copy];
    self.detailTextLabel.text = self.rowVM.valueArray ? [self.rowVM.valueArray componentsJoinedByString:@","] : @"";
    self.placeholderLabel.hidden = self.detailTextLabel.text.length > 0;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!self.selected){
        [self setSelected:YES animated:NO];
    }
    
    [self.rowVM.valueArray enumerateObjectsUsingBlock:^(NSString *  _Nonnull valueElement, NSUInteger idx, BOOL * _Nonnull stop) {
        if (self.rowVM.optionsArray.count > idx) {
            NSArray *componentArray = self.rowVM.optionsArray[idx];
            NSInteger destRow = [componentArray indexOfObject:valueElement];
            [self.pickerView selectRow:destRow inComponent:idx animated:NO];
        }
    }];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self setSelected:NO animated:NO];
    [self.rowVM deselectRowAnimated:NO];
    [self updateCurrentValue];
    return YES;
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.rowVM.optionsArray.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray<NSString *> *titlesArray = [self.rowVM.optionsArray objectAtIndex:component];
    NSAssert([titlesArray isKindOfClass:[NSArray class]], @"elements of optionsArray is also array");
    return [titlesArray count];
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray<NSString *> *titlesArray = [self.rowVM.optionsArray objectAtIndex:component];
    return [titlesArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self updateCurrentValue];
    if (self.rowVM.onValueChangeHandler){
        self.rowVM.onValueChangeHandler(self.rowVM);
    }
    
    [pickerView reloadAllComponents];
    [self updateCurrentValue];
    
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

- (UIPickerView *)pickerView
{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectNull];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
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
