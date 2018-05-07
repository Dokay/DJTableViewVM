//
//  DJTableViewVMChooseBaseRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/11/17.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRow.h"
#import "DJInputRowProtocol.h"

@interface DJTableViewVMChooseBaseRow : DJTableViewVMRow<DJInputRowProtocol>

#pragma mark DJInputRowProtocol
//@property (nonatomic, assign) BOOL enabled;//whether cell is edit enable
@property (nonatomic, assign) UITableViewScrollPosition focusScrollPosition;//scrollPosition for cell be focus while input.it works when keyboardManageEnabled in DJTableViewVM set YES.
@property (nonatomic, strong) UIColor *toolbarTintColor;

@property (nonatomic, strong) UIView *inputAccessoryView;
@property (nonatomic, assign) BOOL showInputAccessoryView;

@end
