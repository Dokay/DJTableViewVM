//
//  DJTableViewVM+Keyboard.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/20.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVM+Keyboard.h"
#import "DJTableViewVMInputBaseRow.h"
#import <objc/runtime.h>
#import "DJToolBar.h"

@interface DJKeyboardState : NSObject

@property(nonatomic, assign) UIEdgeInsets contentInset;//original contentInset
@property(nonatomic, assign) UIEdgeInsets scrollIndicatorInsets;//original scrollIndicatorInsets
@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic, assign) BOOL isKeyboardRegist;//whether keyborad notification has resigted.
@property(nonatomic, assign) BOOL isInfoSaved;//whether orignial tableview info has saved.
@property(nonatomic, weak) DJToolBar *toolBar;

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
        
        state.isKeyboardRegist = YES;
    }
    
}

- (void)unregistKeyboard
{
    DJKeyboardState *state = [self keyboardState];
    if (state.isKeyboardRegist == YES) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        
        state.isKeyboardRegist = NO;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    UIView *responderView;
    UITableViewScrollPosition focusScrollPosition;
    DJTableViewVMInputBaseRow *inputRowVM = [self inputRowVMInCurrentVM];
    focusScrollPosition = ((DJTableViewVMInputBaseRow *)inputRowVM).focusScrollPosition;
    
    UITableViewCell<DJInputCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
    if ([cell respondsToSelector:@selector(inputResponder)]) {
        responderView = [cell inputResponder];
    }
    if (inputRowVM == nil || responderView == nil) {
        //keyboard shown for view that not in DJTableViewVM
        return;
    }
    
    DJKeyboardState *state = [self keyboardState];
    if (state.isInfoSaved == NO) {
        state.isInfoSaved = YES;
        state.scrollIndicatorInsets = self.tableView.scrollIndicatorInsets;
        state.contentInset = self.tableView.contentInset;
    }
    [self configToolBarWithRowVM:inputRowVM forCurrentState:state];
    [self addTapGestureToHideKeyboard];
    
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    UIViewAnimationOptions animationOptions = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    CGRect keyboardRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    {
        //caculate content inset
        CGRect tableViewRectInWindow = [self.tableView.superview convertRect:self.tableView.frame toView:self.tableView.window];
        CGFloat bottomInsetFixHeight = keyboardRect.size.height - (self.tableView.window.bounds.size.height - tableViewRectInWindow.size.height - tableViewRectInWindow.origin.y);
        
        UIEdgeInsets destContentInsets = state.contentInset;
        destContentInsets.bottom += bottomInsetFixHeight;
        UIEdgeInsets destScrollIndicatorInsets = state.scrollIndicatorInsets;
        destScrollIndicatorInsets.bottom += bottomInsetFixHeight;
        
        //caculate content offset
        CGRect responderViewInTableView = [responderView.superview convertRect:responderView.frame toView:self.tableView];
        CGFloat tableViewScrollHeight = self.tableView.bounds.size.height - destContentInsets.top - destContentInsets.bottom;
        CGFloat responderViewTopOffsetInView = 0.0f;
        CGFloat destScrollOffset = 0.0f;
        switch (focusScrollPosition) {
            case UITableViewScrollPositionNone:
            {
                //need not scroll
            }
                break;
            case UITableViewScrollPositionTop:
            {
                responderViewTopOffsetInView = 0.0f;
            }
                break;
            case UITableViewScrollPositionMiddle:
            {
                responderViewTopOffsetInView = (tableViewScrollHeight - responderView.frame.size.height)/2;
            }
                break;
            case UITableViewScrollPositionBottom:
            {
                responderViewTopOffsetInView = tableViewScrollHeight - responderView.frame.size.height;
            }
                break;
            default:
                break;
        }
        
        if (focusScrollPosition != UITableViewScrollPositionNone) {
            destScrollOffset = responderViewInTableView.origin.y - responderViewTopOffsetInView - destContentInsets.top;
            destScrollOffset += self.offsetUnderResponder;
        }else{
            destScrollOffset = self.tableView.contentOffset.y;
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

- (void)keyboardWillHide:(NSNotification *)notification {
    
    UIView *responderView;
    DJTableViewVMInputBaseRow *inputRowVM = [self inputRowVMInCurrentVM];
    UITableViewCell<DJInputCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
    if ([cell respondsToSelector:@selector(inputResponder)]) {
        responderView = [cell inputResponder];
    }
    if (inputRowVM == nil || responderView == nil) {
        //keyboard shown for view that not in DJTableViewVM
        return;
    }
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    DJKeyboardState *state = [self keyboardState];
    UIEdgeInsets destContentInsets = state.contentInset;
    UIEdgeInsets destScrollIndicatorInsets = state.scrollIndicatorInsets;
    state.isInfoSaved = NO;
    if (state.tapGesture) {
        [state.tapGesture removeTarget:self action:@selector(onTapTableView:)];
    }
    
    [UIView animateWithDuration:animationDuration delay:0 options:(UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState) animations:^{
        self.tableView.contentInset = destContentInsets;
        self.tableView.scrollIndicatorInsets = destScrollIndicatorInsets;
        [self.tableView layoutIfNeeded];
    } completion:NULL];
}

- (DJTableViewVMInputBaseRow *)inputRowVMInCurrentVM
{
    __block DJTableViewVMInputBaseRow *inputRowVM;
    [self.sections enumerateObjectsUsingBlock:^(DJTableViewVMSection * _Nonnull sectionVM, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionVM.rows enumerateObjectsUsingBlock:^(DJTableViewVMRow * _Nonnull rowVM, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([rowVM isKindOfClass:[DJTableViewVMInputBaseRow class]]) {
                if (((DJTableViewVMInputBaseRow *)rowVM).editing) {
                    inputRowVM = (DJTableViewVMInputBaseRow *)rowVM;
                    *stop = YES;
                }
            }
        }];
    }];
    return inputRowVM;
}

#pragma mark - hide keyboard
- (void)addTapGestureToHideKeyboard
{
    if (self.tapHideKeyboardEnable) {
        DJKeyboardState *state = [self keyboardState];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapTableView:)];
        [self.tableView addGestureRecognizer:tapGesture];
        state.tapGesture = tapGesture;
    }
}

- (void)onTapTableView:(UITapGestureRecognizer *)gesture
{
    if (self.tapHideKeyboardEnable) {
        [self hideKeyboard];
    }
}

- (void)hideKeyboard
{
    [self.sections enumerateObjectsUsingBlock:^(DJTableViewVMSection * _Nonnull sectionVM, NSUInteger idx, BOOL * _Nonnull stop) {
        [sectionVM.rows enumerateObjectsUsingBlock:^(DJTableViewVMRow * _Nonnull rowVM, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([rowVM isKindOfClass:[DJTableViewVMInputBaseRow class]]) {
                if (((DJTableViewVMInputBaseRow *)rowVM).enabled
                    &&((DJTableViewVMInputBaseRow *)rowVM).editing) {
                    UITableViewCell<DJInputCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:rowVM.indexPath];
                    [cell resignFirstResponder];
                    *stop = YES;
                }
            }
        }];
    }];
    
}

- (void)scrollHideKeyboard
{
    if (self.scrollHideKeyboadEnable) {
        [self hideKeyboard];
    }
}

#pragma mark - toolbar methods
- (void)configToolBarWithRowVM:(DJTableViewVMInputBaseRow *)inputRowVM forCurrentState:(DJKeyboardState *)state
{
    if (inputRowVM.inputAccessoryView != nil && [inputRowVM.inputAccessoryView isKindOfClass:[DJToolBar class]]) {
        DJToolBar *keyboardToolBar = (DJToolBar *)inputRowVM.inputAccessoryView;
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
            UITableViewCell<DJInputCellProtocol> *cell = [weakSelf.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
            [cell resignFirstResponder];
        }];
        [keyboardToolBar setNeedsLayout];
        state.toolBar = keyboardToolBar;
    }
}

- (DJTableViewVMInputBaseRow *)inputRowVMBeforeIndexPath:(NSIndexPath *)indexPath
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
            if ([rowVM isKindOfClass:[DJTableViewVMInputBaseRow class]]) {
                DJTableViewVMInputBaseRow *inputRowVM = (DJTableViewVMInputBaseRow *)rowVM;
                if (inputRowVM.enabled == YES
                    && inputRowVM.editing == NO) {
                    return inputRowVM;
                }
            }
        }
    }
    return nil;
}

- (DJTableViewVMInputBaseRow *)inputRowVMAfterIndexPath:(NSIndexPath *)indexPath
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
            if ([rowVM isKindOfClass:[DJTableViewVMInputBaseRow class]]) {
                DJTableViewVMInputBaseRow *inputRowVM = (DJTableViewVMInputBaseRow *)rowVM;
                if (inputRowVM.enabled == YES
                    && inputRowVM.editing == NO) {
                    return inputRowVM;
                }
            }
        }
    }
    return nil;
}

- (void)jumpToPreInputCellBeforeIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMInputBaseRow *inputRowVM = [self inputRowVMBeforeIndexPath:indexPath];
    if (inputRowVM != nil) {
        UITableViewCell<DJInputCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
        UIView *responderView = [cell inputResponder];
        if ([responderView respondsToSelector:@selector(becomeFirstResponder)]) {
            [responderView becomeFirstResponder];
        }
    }
}

- (void)jumpToNextInputCellAfterIndexPath:(NSIndexPath *)indexPath
{
    DJTableViewVMInputBaseRow *inputRowVM = [self inputRowVMAfterIndexPath:indexPath];
    if (inputRowVM != nil) {
        UITableViewCell<DJInputCellProtocol> *cell = [self.tableView cellForRowAtIndexPath:inputRowVM.indexPath];
        UIView *responderView = [cell inputResponder];
        if ([responderView respondsToSelector:@selector(becomeFirstResponder)]) {
            [responderView becomeFirstResponder];
        }
    }
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
