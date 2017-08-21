//
//  DJTableViewVMTextViewCell.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMTextViewCell.h"
#import "DJTableViewVM.h"
#import "DJToolBar.h"

#define MagicMarginNumber DJTableViewVMTextViewRowMagicMarginNumber

@interface DJTableViewVMTextViewCell()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) UILabel *placeholderLabel;
@property(nonatomic, strong) UILabel *charactersLabel;

@end

@implementation DJTableViewVMTextViewCell
@dynamic rowVM;

#pragma mark - overwrite
- (void)cellDidLoad
{
    [super cellDidLoad];
    
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.placeholderLabel];
    [self.contentView addSubview:self.charactersLabel];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    DJTableViewVMTextViewRow *textRow = self.rowVM;
    self.placeholderLabel.text = textRow.placeholder;
    self.placeholderLabel.textColor = textRow.placeholderColor;
    self.placeholderLabel.font = textRow.placeholderFont;
    if (textRow.attributedPlaceholder) {
        self.placeholderLabel.attributedText = textRow.attributedPlaceholder;
    }
    
    self.charactersLabel.textColor = textRow.charactersCountColor;
    self.charactersLabel.font = textRow.charactersCountFont;
    
    self.textView.text = textRow.text;
    self.textView.textColor = textRow.textColor;
    self.textView.font = textRow.font;
    self.textView.textAlignment = textRow.textAlignment;
    self.textView.selectedRange = textRow.selectedRange;
    self.textView.editable = textRow.editable;
    self.textView.selectable = textRow.selectable;
    self.textView.dataDetectorTypes = textRow.dataDetectorTypes;
    self.textView.allowsEditingTextAttributes = textRow.allowsEditingTextAttributes;
    self.textView.textContainerInset = textRow.textContainerInset;
    self.textView.inputView = textRow.inputView;
    
    if (self.rowVM.sectionVM.tableViewVM.keyboardManageEnabled && textRow.inputAccessoryView == nil) {
        textRow.inputAccessoryView = [DJToolBar new];
    }
    if ([textRow.inputAccessoryView isKindOfClass:[DJToolBar class]]
        && [textRow respondsToSelector:@selector(toolbarTintColor)]) {
        ((DJToolBar *)textRow.inputAccessoryView).tintColor = textRow.toolbarTintColor;
    }
    self.textView.inputAccessoryView = textRow.inputAccessoryView;
    
    self.userInteractionEnabled = textRow.enabled;
    
    if (textRow.attributedText) {
        self.textView.attributedText = textRow.attributedText;
    }
    if (textRow.typingAttributes) {
        self.textView.typingAttributes = textRow.typingAttributes;
    }
    
    [self refreshLabelsWithTextView:self.textView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.textView becomeFirstResponder];
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
    }
    self.textView.frame = CGRectMake(textFieldLeft + self.rowVM.textFiledLeftMargin, 0, contentSize.width - textFieldLeft - self.separatorInset.right, contentSize.height);
    
    CGRect textFrame = CGRectMake(self.textView.frame.origin.x + self.rowVM.textContainerInset.left + MagicMarginNumber, self.textView.frame.origin.y + self.rowVM.textContainerInset.top, self.textView.frame.size.width, self.textView.frame.size.height - self.rowVM.textContainerInset.top - self.rowVM.textContainerInset.bottom);
    CGRect placeholderRect = [self.placeholderLabel textRectForBounds:textFrame limitedToNumberOfLines:0];
    self.placeholderLabel.frame = placeholderRect;
    
    self.charactersLabel.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y + self.textView.frame.size.height - 20, self.textView.frame.size.width - 10, 20);
}

- (BOOL)becomeFirstResponder
{
    [self.textView becomeFirstResponder];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}

#pragma mark - private methods
- (void)refreshLabelsWithTextView:(UITextView *)textView
{
    self.placeholderLabel.hidden = textView.text.length != 0;
    
    self.charactersLabel.text = [NSString stringWithFormat:@"%@/%@",@(textView.text.length),@(self.rowVM.charactersMaxCount)];
    self.charactersLabel.hidden = self.rowVM.showCharactersCount != YES || self.rowVM.charactersMaxCount == 0;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    BOOL should = YES;
    if (self.rowVM.shouldBeginEditing) {
        should = self.rowVM.shouldBeginEditing(self.rowVM);
    }
    return should;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    BOOL should = YES;
    if (self.rowVM.shouldEndEditing) {
        should =  self.rowVM.shouldEndEditing(self.rowVM);
    }
    return should;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.rowVM.didBeginEditing) {
        self.rowVM.didBeginEditing(self.rowVM);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.rowVM.didEndEditing) {
        self.rowVM.didEndEditing(self.rowVM);
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.rowVM.shouldChangeCharacterInRange){
        return self.rowVM.shouldChangeCharacterInRange(self.rowVM, range, text);
    }
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *toBeString = textView.text;
    
    if (self.rowVM.charactersMaxCount > 0) {
        UITextRange *selectedRange = textView.markedTextRange;
        if (!selectedRange || !selectedRange.start) {
            if (toBeString.length > self.rowVM.charactersMaxCount) {
                textView.text = [toBeString substringToIndex:self.rowVM.charactersMaxCount];
                if (self.rowVM.maxCountInputMore) {
                    self.rowVM.maxCountInputMore(self.rowVM);
                }
            }
        }
    }
    
    self.rowVM.text = textView.text;
    if (self.rowVM.textChanged){
        self.rowVM.textChanged(self.rowVM);
    }
    
    [self refreshLabelsWithTextView:textView];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (self.rowVM.didChangeSelection){
        self.rowVM.didChangeSelection(self.rowVM, textView.selectedRange);
    }
}

//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
//{
//    return YES;
//}
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
//{
//    return YES;
//}

#pragma mark - getter
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [UITextView new];
        _textView.frame = self.contentView.bounds;
        _textView.delegate = self;
    }
    return _textView;
}

- (UILabel *)placeholderLabel
{
    if (_placeholderLabel == nil) {
        _placeholderLabel = [UILabel new];
        _placeholderLabel.textAlignment = NSTextAlignmentLeft;
        _placeholderLabel.userInteractionEnabled = NO;
        _placeholderLabel.numberOfLines = 0;
    }
    return _placeholderLabel;
}

- (UILabel *)charactersLabel
{
    if (_charactersLabel == nil) {
        _charactersLabel = [UILabel new];
        _charactersLabel.textAlignment = NSTextAlignmentRight;
        _charactersLabel.userInteractionEnabled = NO;
    }
    return _charactersLabel;
}

@end
