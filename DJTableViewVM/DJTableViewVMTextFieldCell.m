//
//  DJTableViewVMTextFieldCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/16.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextFieldCell.h"
#import "DJTableViewVM.h"

@interface DJTableViewVMTextFieldCell()<UITextFieldDelegate>


@end

@interface DJTableViewVMTextFieldCell()

@end

@implementation DJTableViewVMTextFieldCell
@dynamic rowVM;

#pragma mark - overwrite
- (void)cellDidLoad
{
    [super cellDidLoad];

    [self.contentView addSubview:self.textField];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DJTableViewVMTextFieldCellRow *textRow = self.rowVM;
    
    self.textField.placeholder = textRow.placeholder;
    self.textField.text = textRow.text;
    self.textField.textAlignment = textRow.textAlignment;
    self.textField.font = textRow.font;
    self.textField.textColor = textRow.textColor;
    self.textField.clearsOnBeginEditing = textRow.clearsOnBeginEditing;
    self.textField.clearButtonMode = textRow.clearButtonMode;
    self.textField.enabled = textRow.enabled;
    
    self.textField.borderStyle = textRow.borderStyle;
    self.textField.adjustsFontSizeToFitWidth = textRow.adjustsFontSizeToFitWidth;
    self.textField.minimumFontSize = textRow.minimumFontSize;
    self.textField.background = textRow.background;
    self.textField.disabledBackground = textRow.disabledBackground;
    self.textField.leftView = textRow.leftView;
    self.textField.leftViewMode = textRow.leftViewMode;
    self.textField.rightView = textRow.rightView;
    self.textField.rightViewMode = textRow.rightViewMode;
    self.textField.clearsOnInsertion = textRow.clearsOnInsertion;
    
    self.textField.autocapitalizationType = textRow.autocapitalizationType;
    self.textField.autocorrectionType = textRow.autocorrectionType;
    self.textField.spellCheckingType = textRow.spellCheckingType;
    self.textField.keyboardType = textRow.keyboardType;
    self.textField.returnKeyType = textRow.returnKeyType;
    self.textField.keyboardAppearance = textRow.keyboardAppearance;
    self.textField.enablesReturnKeyAutomatically = textRow.enablesReturnKeyAutomatically;
    self.textField.secureTextEntry = textRow.secureTextEntry;
    
    self.textField.inputView = textRow.inputView;
    self.textField.inputAccessoryView = textRow.inputAccessoryView;
    
    if (textRow.attributedPlaceholder) {
        self.textField.attributedPlaceholder = textRow.attributedPlaceholder;
    }
    if (textRow.attributedText) {
        self.textField.attributedText = textRow.attributedText;
    }
    if (textRow.defaultTextAttributes) {
        self.textField.defaultTextAttributes = textRow.defaultTextAttributes;
    }
    
    self.userInteractionEnabled = textRow.enabled;
    
    if (textRow.editing && [self.textField isFirstResponder] == NO) {
        [self.textField becomeFirstResponder];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.textField becomeFirstResponder];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize contentSize = self.contentView.frame.size;
    CGFloat textFieldLeft = self.separatorInset.left;
    if (self.rowVM.title.length > 0) {
        CGFloat titleLength = [self.rowVM.title sizeWithAttributes:@{NSFontAttributeName:self.textLabel.font}].width;
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, titleLength, self.textLabel.frame.size.height);
        textFieldLeft = self.textLabel.frame.origin.x + self.textLabel.frame.size.width + self.rowVM.textFiledLeftMargin;
        self.textField.frame = CGRectMake(textFieldLeft, (contentSize.height - self.textField.frame.size.height)/2, contentSize.width - textFieldLeft - self.separatorInset.right , self.textField.frame.size.height);
    }else{
        self.textField.frame = CGRectMake(textFieldLeft + self.rowVM.textFiledLeftMargin, (contentSize.height - self.textField.frame.size.height)/2, contentSize.width - self.separatorInset.left - self.separatorInset.right , self.textField.frame.size.height);
    }
}

- (BOOL)resignFirstResponder
{
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}

- (UIView *)inputResponder
{
    return self.textField;
}

#pragma mark - events
- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    
    if (self.rowVM.charactersMaxCount > 0) {
        UITextRange *selectedRange = textField.markedTextRange;
        if (!selectedRange || !selectedRange.start) {
            if (toBeString.length > self.rowVM.charactersMaxCount) {
                textField.text = [toBeString substringToIndex:self.rowVM.charactersMaxCount];
                if (self.rowVM.maxCountInputMore) {
                    self.rowVM.maxCountInputMore(self.rowVM);
                }
            }
        }
    }
    
    self.rowVM.text = textField.text;
    if (self.rowVM.textChanged){
        self.rowVM.textChanged(self.rowVM);
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL should = YES;
    if (self.rowVM.shouldBeginEditing) {
        should = self.rowVM.shouldBeginEditing(self.rowVM);
    }
    if (should) {
        self.rowVM.editing = YES;
    }
    return should;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.rowVM.didBeginEditing) {
        self.rowVM.didBeginEditing(self.rowVM);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    BOOL should = YES;
    if (self.rowVM.shouldEndEditing) {
        should =  self.rowVM.shouldEndEditing(self.rowVM);
    }
    return should;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.rowVM.didEndEditing) {
        self.rowVM.didEndEditing(self.rowVM);
    }

    self.rowVM.editing = NO;
}

//note:called in place of textFieldDidEndEditing:
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0)
{
    if(self.rowVM.didEndEditingWithReason){
        self.rowVM.didEndEditingWithReason(self.rowVM, reason);
    }
    
    if (self.rowVM.didEndEditing) {
        self.rowVM.didEndEditing(self.rowVM);
    }
    
    self.rowVM.editing = NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.rowVM.shouldChangeCharacterInRange){
        return self.rowVM.shouldChangeCharacterInRange(self.rowVM, range, string);
    }
    
    if ([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    BOOL should = YES;
    if (self.rowVM.shouldClear) {
        should = self.rowVM.shouldClear(self.rowVM);
    }
    return should;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL should = YES;
    if (self.rowVM.shouldClear) {
        should = self.rowVM.shouldClear(self.rowVM);
    }
    if (should) {
        [textField resignFirstResponder];
    }
    return should;
}

#pragma mark - getter
- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [UITextField new];
        _textField.delegate = self;
        _textField.frame = self.contentView.bounds;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

@end
