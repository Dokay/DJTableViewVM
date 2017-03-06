//
//  DJTableViewVMInputBaseRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/6.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRow.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DJInputCellProtocol <NSObject>

- (UIView *)inputResponder;//return a responder view.The view is used to scroll to good target offset auto.

@end

@interface DJTableViewVMInputBaseRow : DJTableViewVMRow

@property (nonatomic, assign) BOOL editing;//whether cell is editing.default is NO.
@property (nonatomic, assign) BOOL enabled;//whether cell is edit enable.default is YES.
@property (nonatomic, assign) UITableViewScrollPosition focusScrollPosition;//scrollPosition for cell be focus while input.default is UITableViewScrollPositionBottom.it works when keyboardManageEnabled in DJTableViewVM set YES.
@property (nullable, nonatomic, strong) UIView *inputAccessoryView;//deault value is an instance of DJToolBar.

@property (nullable, nonatomic, strong) UIColor *toolbarTintColor;

@end

NS_ASSUME_NONNULL_END
