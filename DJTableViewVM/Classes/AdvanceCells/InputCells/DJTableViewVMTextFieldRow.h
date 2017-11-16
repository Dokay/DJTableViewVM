//
//  DJTableViewVMTextFieldRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/1.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRow.h"
#import "DJInputRowProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMTextFieldRow : DJTableViewVMRow<DJInputRowProtocol>

//@property (nonatomic, assign) BOOL enabled;//whether cell is edit enable.default is YES.
@property (nonatomic, assign) UITableViewScrollPosition focusScrollPosition;//scrollPosition for cell be focus while input.default is UITableViewScrollPositionBottom.it works when keyboardManageEnabled in DJTableViewVM set YES.
@property (nullable, nonatomic, strong) UIColor *toolbarTintColor;

@property (nonatomic, assign) NSUInteger charactersMaxCount;//max characters can input.default is 0,means has no restrict.
@property (nonatomic, assign) CGFloat textFiledLeftMargin;//left margin for textFiled.default is 0.

#pragma mark - UITextInputTraits properties
@property(nonatomic) UITextAutocapitalizationType autocapitalizationType; // default is UITextAutocapitalizationTypeSentences
@property(nonatomic) UITextAutocorrectionType autocorrectionType;         // default is UITextAutocorrectionTypeDefault
@property(nonatomic) UITextSpellCheckingType spellCheckingType NS_AVAILABLE_IOS(5_0); // default is UITextSpellCheckingTypeDefault;
@property(nonatomic) UIKeyboardType keyboardType;                         // default is UIKeyboardTypeDefault
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;             // default is UIKeyboardAppearanceDefault
@property(nonatomic) UIReturnKeyType returnKeyType;                       // default is UIReturnKeyDefault (See note under UIReturnKeyType enum)
@property(nonatomic) BOOL enablesReturnKeyAutomatically;                  // default is NO (when YES, will automatically disable return key when text widget has zero-length contents, and will automatically enable when text widget has non-zero-length contents)
@property(nonatomic,getter=isSecureTextEntry) BOOL secureTextEntry;       // default is NO

#pragma mark - UITextField properties
@property(nullable, nonatomic,copy)   NSString               *text;                 // default is nil
@property(nullable, nonatomic,copy)   NSAttributedString     *attributedText NS_AVAILABLE_IOS(6_0); // default is nil
@property(nullable, nonatomic,strong) UIColor                *textColor;            // default is nil. use opaque black
@property(nullable, nonatomic,strong) UIFont                 *font;                 // default is nil. use system font 12 pt
@property(nonatomic)        NSTextAlignment         textAlignment;        // default is NSLeftTextAlignment
@property(nonatomic)        UITextBorderStyle       borderStyle;          // default is UITextBorderStyleNone. If set to UITextBorderStyleRoundedRect, custom background images are ignored.
@property(nonatomic,copy)   NSDictionary<NSString *, id>           *defaultTextAttributes NS_AVAILABLE_IOS(7_0); // applies attributes to the full range of text. Unset attributes act like default values.

@property(nullable, nonatomic,copy)   NSString               *placeholder;          // default is nil. string is drawn 70% gray
@property(nullable, nonatomic,copy)   NSAttributedString     *attributedPlaceholder NS_AVAILABLE_IOS(6_0); // default is nil
@property(nonatomic)        BOOL                    clearsOnBeginEditing; // default is NO which moves cursor to location clicked. if YES, all text cleared
@property(nonatomic)        BOOL                    adjustsFontSizeToFitWidth; // default is NO. if YES, text will shrink to minFontSize along baseline
@property(nonatomic)        CGFloat                 minimumFontSize;      // default is 0.0. actual min may be pinned to something readable. used if adjustsFontSizeToFitWidth is YES
@property(nullable, nonatomic,strong) UIImage                *background;           // default is nil. draw in border rect. image should be stretchable
@property(nullable, nonatomic,strong) UIImage                *disabledBackground;   // default is nil. ignored if background not set. image should be stretchable
@property(nonatomic)        UITextFieldViewMode  clearButtonMode; // sets when the clear button shows up. default is UITextFieldViewModeNever

@property(nullable, nonatomic,strong) UIView              *leftView;        // e.g. magnifying glass
@property(nonatomic)        UITextFieldViewMode  leftViewMode;    // sets when the left view shows up. default is UITextFieldViewModeNever

@property(nullable, nonatomic,strong) UIView              *rightView;       // e.g. bookmarks button
@property(nonatomic)        UITextFieldViewMode  rightViewMode;   // sets when the right view shows up. default is UITextFieldViewModeNever

// Presented when object becomes first responder.  If set to nil, reverts to following responder chain.  If
// set while first responder, will not take effect until reloadInputViews is called.
@property (nullable, readwrite, strong) UIView *inputView;
@property (nullable, nonatomic, strong) UIView *inputAccessoryView;
@property (nonatomic, assign) BOOL showInputAccessoryView;

@property(nonatomic) BOOL clearsOnInsertion NS_AVAILABLE_IOS(6_0); // defaults to NO. if YES, the selection UI is hidden, and inserting text will replace the contents of the field. changing the selection will automatically set this to NO.

#pragma mark - actions
@property (nonatomic, copy) void (^textChanged)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) void (^didBeginEditing)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) void (^didEndEditing)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) void (^maxCountInputMore)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) void (^didEndEditingWithReason)(DJTableViewVMTextFieldRow *rowVM,UITextFieldDidEndEditingReason reason) NS_AVAILABLE_IOS(10_0);
@property (nonatomic, copy) BOOL (^shouldReturn)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) BOOL (^shouldBeginEditing)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) BOOL (^shouldEndEditing)(DJTableViewVMTextFieldRow *rowVM);
@property (nonatomic, copy) BOOL (^shouldChangeCharacterInRange)(DJTableViewVMTextFieldRow *rowVM, NSRange range, NSString *replacementString);
@property (nonatomic, copy) BOOL (^shouldClear)(DJTableViewVMTextFieldRow *rowVM);
@end

NS_ASSUME_NONNULL_END
