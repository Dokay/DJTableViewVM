//
//  DJTableViewVMRelatedPickerRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>
#import "DJInputRowProtocol.h"
#import "DJValueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMRelatedPickerRow : DJTableViewVMRow<DJInputRowProtocol>

#pragma mark DJInputRowProtocol
//@property (nonatomic, assign) BOOL enabled;//whether cell is edit enable
@property (nonatomic, assign) UITableViewScrollPosition focusScrollPosition;//scrollPosition for cell be focus while input.it works when keyboardManageEnabled in DJTableViewVM set YES.
@property (nullable, nonatomic, strong) UIColor *toolbarTintColor;

@property(nonatomic, copy) NSArray<NSString *> *valueArray;
@property(nonatomic, copy, nullable) NSString *placeholder;//drawn 70% gray
@property(nonatomic, copy, nullable) NSAttributedString *attributedPlaceholder;//default is nil
@property(nonatomic, readonly) NSArray<NSNumber *> *selectIndexArray;
@property(nonatomic, copy) NSArray<NSArray<DJRelatedPickerValueProtocol> *> *relatedOptionsArray;

@property(nonatomic, copy) void(^onValueChangeHandler)(DJTableViewVMRelatedPickerRow *rowVM);

- (id)initWithTitle:(NSString *)title value:(NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder relatedPptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)relatedOptionsArray;

@end

NS_ASSUME_NONNULL_END
