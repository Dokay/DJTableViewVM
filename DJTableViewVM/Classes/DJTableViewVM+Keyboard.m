//
//  DJTableViewVM+Keyboard.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/20.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVM+Keyboard.h"
#import "DJInputRowProtocol.h"
#import <objc/runtime.h>
#import "DJToolBar.h"

@interface DJKeyboardState : NSObject

@property(nonatomic, assign) UIEdgeInsets contentInset;//original contentInset
@property(nonatomic, assign) UIEdgeInsets scrollIndicatorInsets;//original scrollIndicatorInsets
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic, assign) BOOL isKeyboardRegist;//whether keyborad notification has resigted.
@property(nonatomic, assign) BOOL isInfoSaved;//whether orignial tableview info has saved.
@property(nonatomic, weak) DJToolBar *toolBar;

@property(nonatomic, weak) UIView *responderView;
@property(nonatomic, strong) NSNotification *notification;

@end

@implementation DJKeyboardState

@end

@implementation DJTableViewVM (Keyboard)

- (void)registKeyboard
{
    DJKeyboardState *state = [self keyboardState];
    if (state.isKeyboardRegist == NO) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputDidBeginEditingNotification:)
                                                     name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputDidBeginEditingNotification:)
                                                     name:UITextViewTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputDidBeginEditingNotification:)
                                                     name:UITextViewTextDidChangeNotification object:nil];
        state.isKeyboardRegist = YES;
    }
}

- (void)unregistKeyboard
{
    DJKeyboardState *state = [self keyboardState];
    if (state.isKeyboardRegist == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
        
        state.isKeyboardRegist = NO;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    DJKeyboardState *state = [self keyboardState];
    if (state.isInfoSaved == NO) {
        state.isInfoSaved = YES;
        state.scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        state.contentInset = self.tableView.contentInset;
    }
    state.notification = notification;
    
    [self adjustFrame];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    DJKeyboardState *state = [self keyboardState];
    if (state.responderView == nil || state.isInfoSaved == NO) {
        return;
    }
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    UIEdgeInsets destContentInsets = state.contentInset;
    UIEdgeInsets destScrollIndicatorInsets = state.scrollIndicatorInsets;
    state.isInfoSaved = NO;
    state.notification = nil;
    if (state.tapGesture) {
        [self.tableView.window removeGestureRecognizer:state.tapGesture];
        state.tapGesture = nil;
    }
    
    if (self.keyboardManageEnabled == NO) {
        return;
    }
    [UIView animateWithDuration:animationDuration delay:0
                        options:(animationOptions|UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
        self.tableView.contentInset = destContentInsets;
        self.tableView.scrollIndicatorInsets = destScrollIndicatorInsets;
        [self.tableView layoutIfNeeded];
    } completion:NULL];
}

- (void)inputDidBeginEditingNotification:(NSNotification *)notification
{
    DJKeyboardState *state = [self keyboardState];
    
    UITableViewCell *superCell = [self superCellInTableView:notification.object];
    if (superCell != nil) {
        state.responderView = notification.object;
        
        [self adjustFrame];
    }
}

- (void)adjustFrame
{
    DJKeyboardState *state = [self keyboardState];
    if (state.responderView == nil
        || self.keyboardManageEnabled == NO
        || state.notification == nil) {
        return;
    }
    
    UITableViewCell *superCell = [self superCellInTableView:state.responderView];
    if (superCell == nil) {
        return;
    }
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:superCell];
    if (indexPath == nil) {
        return;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow<DJInputRowProtocol> *inputRowVM = [section.rows objectAtIndex:indexPath.row];
    [self configToolBarWithRowVM:inputRowVM forCurrentState:state];
    if (self.tapHideKeyboardEnable) {
        [self addTapGestureToHideKeyboard];
    }

    UITableViewScrollPosition focusScrollPosition = ((DJTableViewVMRow<DJInputRowProtocol> *)inputRowVM).focusScrollPosition;
    UIView *responderView = state.responderView;
    NSNotification *notification = state.notification;
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (animationDuration == 0.0f) {
        animationDuration = 0.25f;
    }
    UIViewAnimationOptions animationOptions = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    {
        //caculate content inset
        CGRect tableViewRectInWindow = [self.tableView.superview convertRect:self.tableView.frame toView:self.tableView.window];
        CGFloat bottomInsetFixHeight = keyboardRect.size.height - (self.tableView.window.bounds.size.height - tableViewRectInWindow.size.height - tableViewRectInWindow.origin.y);
        bottomInsetFixHeight = MAX(0, bottomInsetFixHeight);
        
        UIEdgeInsets destContentInsets = state.contentInset;
        destContentInsets.bottom += bottomInsetFixHeight;
        UIEdgeInsets destScrollIndicatorInsets = state.scrollIndicatorInsets;
        destScrollIndicatorInsets.bottom += bottomInsetFixHeight;
        
        //caculate content offset
        CGRect responderViewInTableView = [responderView.superview convertRect:responderView.frame toView:self.tableView];
        CGFloat tableViewScrollHeight = self.tableView.bounds.size.height - destContentInsets.top - destContentInsets.bottom;
        
        if (responderViewInTableView.size.height > tableViewScrollHeight) {
            //tableview can not show responderView wholly
            if ([responderView conformsToProtocol:@protocol(UITextInput)]) {
                UIView <UITextInput> *textInputView = (UIView <UITextInput>*)responderView;
                UITextPosition *caretPosition = [textInputView selectedTextRange].start;
                if (caretPosition) {
                    //set the caret in the visible space
                    responderViewInTableView = [self.tableView convertRect:[textInputView caretRectForPosition:caretPosition] fromView:textInputView];
                }
            }
        }
        __block CGFloat responderViewTopOffsetInView = 0.0f;
        __block CGFloat destScrollOffset = 0.0f;
        
       void (^cacluateScrollOffset)() = ^(){
            destScrollOffset = responderViewInTableView.origin.y - responderViewTopOffsetInView - destContentInsets.top;
//            destScrollOffset += self.offsetUnderResponder;
        };
        switch (focusScrollPosition) {
            case UITableViewScrollPositionNone:
            {
                //need not scroll
                destScrollOffset = self.tableView.contentOffset.y;
            }
                break;
            case UITableViewScrollPositionTop:
            {
                responderViewTopOffsetInView = 0.0f;
                cacluateScrollOffset();
            }
                break;
            case UITableViewScrollPositionMiddle:
            {
                responderViewTopOffsetInView = (tableViewScrollHeight - responderViewInTableView.size.height)/2;
                cacluateScrollOffset();
            }
                break;
            case UITableViewScrollPositionBottom:
            {
                responderViewTopOffsetInView = tableViewScrollHeight - responderViewInTableView.size.height - self.offsetUnderResponder;
                cacluateScrollOffset();
            }
                break;
            default:
                break;
        }
        
        CGPoint destContentOffset = self.tableView.contentOffset;
        //cheke destScrollOffset avaliable
        CGFloat scrollAvaliableMax = self.tableView.contentSize.height - tableViewScrollHeight - destContentInsets.top;
        destScrollOffset = MIN(scrollAvaliableMax, destScrollOffset);
        destScrollOffset = MAX(-destContentInsets.top, destScrollOffset);
        destContentOffset.y = destScrollOffset;
        
        [UIView animateWithDuration:animationDuration delay:0 options:(animationOptions|UIViewAnimationOptionBeginFromCurrentState) animations:^{
            self.tableView.contentInset = destContentInsets;
            self.tableView.scrollIndicatorInsets = destScrollIndicatorInsets;
            self.tableView.contentOffset = destContentOffset;
            [self.tableView layoutIfNeeded];
        } completion:NULL];
    }
}

- (UITableViewCell *)superCellInTableView:(UIView *)view
{
    if (view) {
        if ([view.superview isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)view.superview;
        }else{
            if (view.superview.superview) {
                return [self superCellInTableView:view.superview];
            }
        }
    }
    return nil;
}

#pragma mark - hide keyboard
- (void)addTapGestureToHideKeyboard
{
    DJKeyboardState *state = [self keyboardState];
    if (state.tapGesture == nil) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapTableView:)];
        [self.tableView.window addGestureRecognizer:tapGesture];
        state.tapGesture = tapGesture;
    }
}

- (void)onTapTableView:(UITapGestureRecognizer *)gesture
{
    if (self.tapHideKeyboardEnable) {
        [self hideKeyboard];
    }
}

- (void)scrollHideKeyboard
{
    if (self.scrollHideKeyboadEnable) {
        [self hideKeyboard];
    }
}

- (void)hideKeyboard
{
    DJKeyboardState *state = [self keyboardState];
    if (state.responderView) {
       [state.responderView resignFirstResponder];
    }
}

#pragma mark - toolbar methods
- (void)configToolBarWithRowVM:(DJTableViewVMRow<DJInputRowProtocol> *)inputRowVM forCurrentState:(DJKeyboardState *)state
{
    UIView *inputView = state.responderView;
    UIView *inputAccessoryView;
    if ([inputView isKindOfClass:[UITextView class]]) {
        inputAccessoryView = ((UITextView *)inputView).inputAccessoryView;
    }
    if ([inputView isKindOfClass:[UITextField class]]) {
        inputAccessoryView = ((UITextField *)inputView).inputAccessoryView;
    }
    if (inputAccessoryView == nil) {
        return;
    }

    if (inputAccessoryView != nil
        && [inputAccessoryView isKindOfClass:[DJToolBar class]]) {
        DJToolBar *keyboardToolBar = (DJToolBar *)inputAccessoryView;
        keyboardToolBar.preEnable = [self inputRowVMBeforeIndexPath:inputRowVM.indexPath] != nil;
        keyboardToolBar.nextEnable = [self inputRowVMAfterIndexPath:inputRowVM.indexPath] != nil;
        
        __weak typeof(self) weakSelf = self;
        [keyboardToolBar setTapPreHandler:^{
            [weakSelf jumpToPreInputCellBeforeIndexPath:inputRowVM.indexPath];
        }];
        [keyboardToolBar setTapNextHandler:^{
            [weakSelf jumpToNextInputCellAfterIndexPath:inputRowVM.indexPath];
        }];
        [keyboardToolBar setTapDoneHandler:^{
            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
            [cell resignFirstResponder];
        }];
        [keyboardToolBar setNeedsLayout];
        state.toolBar = keyboardToolBar;
    }
}

- (DJTableViewVMRow<DJInputRowProtocol> *)inputRowVMBeforeIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger section = indexPath.section; section >= 0; section--) {
        NSInteger currentRowIndex = indexPath.row;
        if (section != indexPath.section) {
            DJTableViewVMSection *sectionVM = self.sections[section];
            currentRowIndex = sectionVM.rows.count - 1;//another section from last row
        }
        for (NSInteger row = currentRowIndex; row > 0; row--) {
            DJTableViewVMSection *sectionVMLoop = self.sections[section];
            DJTableViewVMRow *rowVM = sectionVMLoop.rows[row];
            if ([rowVM conformsToProtocol:@protocol(DJInputRowProtocol)]) {
                DJTableViewVMRow<DJInputRowProtocol> *inputRowVM = (DJTableViewVMRow<DJInputRowProtocol> *)rowVM;
                if (inputRowVM.enabled == YES
                    && (indexPath.row != row || indexPath.section != section)){
                    return inputRowVM;
                }
            }
        }
    }
    return nil;
}

- (DJTableViewVMRow<DJInputRowProtocol> *)inputRowVMAfterIndexPath:(NSIndexPath *)indexPath
{
    for (NSInteger section = indexPath.section; section < self.sections.count; section++) {
        NSInteger currentRowIndex = indexPath.row;
        DJTableViewVMSection *sectionVM = self.sections[section];
        if (section != indexPath.section) {
            currentRowIndex = 0;//another section form first row
        }
        for (NSInteger row = currentRowIndex; row < sectionVM.rows.count; row++) {
            DJTableViewVMSection *sectionVMLoop = self.sections[section];
            DJTableViewVMRow *rowVM = sectionVMLoop.rows[row];
            if ([rowVM conformsToProtocol:@protocol(DJInputRowProtocol)]) {
                DJTableViewVMRow<DJInputRowProtocol> *inputRowVM = (DJTableViewVMRow<DJInputRowProtocol> *)rowVM;
                if (inputRowVM.enabled == YES
                    && (indexPath.row != row || indexPath.section != section)) {
                    return inputRowVM;
                }
            }
        }
    }
    return nil;
}

- (void)jumpToPreInputCellBeforeIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMRow<DJInputRowProtocol> *inputRowVM = [self inputRowVMBeforeIndexPath:indexPath];
    if (inputRowVM != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
        if (cell) {
           [cell becomeFirstResponder];
        }else{
            //cell is not visiable in tableView
            [self jumpUnvisiableCellForRow:inputRowVM];
        }
    }
}

- (void)jumpToNextInputCellAfterIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMRow<DJInputRowProtocol> *inputRowVM = [self inputRowVMAfterIndexPath:indexPath];
    if (inputRowVM != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
        if (cell) {
            [cell becomeFirstResponder];
        }else{
            //cell is not visiable in tableView
            [self jumpUnvisiableCellForRow:inputRowVM];
        }
    }
}

- (void)jumpUnvisiableCellForRow:(DJTableViewVMRow<DJInputRowProtocol> *)inputRowVM
{
    DJKeyboardState *state = [self keyboardState];
    NSTimeInterval animationDuration = [[[state.notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (animationDuration == 0.0f) {
        animationDuration = 0.25f;
    }
    UIViewAnimationOptions animationOptions = [[[state.notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    [UIView animateWithDuration:animationDuration delay:0.0f options:animationOptions | UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.tableView scrollToRowAtIndexPath:inputRowVM.indexPath atScrollPosition:inputRowVM.focusScrollPosition animated:NO];
    } completion:^(BOOL finished) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
        [cell becomeFirstResponder];
    }];
}

#pragma mark - getter & setter
- (DJKeyboardState *)keyboardState
{
    DJKeyboardState *state = objc_getAssociatedObject(self, _cmd);
    if (state == nil) {
        state = [DJKeyboardState new];
        state.isKeyboardRegist = NO;
        [self setKeybordState:state];
    }
    
    return state;
}

- (void)setKeybordState:(DJKeyboardState *)state
{
    objc_setAssociatedObject(self,@selector(keyboardState),state,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
