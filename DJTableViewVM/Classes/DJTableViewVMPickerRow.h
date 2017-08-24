//
//  DJTableViewVMPickerRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/23.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>
#import "DJInputRowProtocol.h"
#import "DJValueProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface DJTableViewVMPickerRow : DJTableViewVMRow<DJInputRowProtocol>

#pragma mark DJInputRowProtocol
//@property (nonatomic, assign) BOOL enabled;//whether cell is edit enable
@property (nonatomic, assign) UITableViewScrollPosition focusScrollPosition;//scrollPosition for cell be focus while input.it works when keyboardManageEnabled in DJTableViewVM set YES.
@property (nullable, nonatomic, strong) UIColor *toolbarTintColor;

@property(nonatomic, copy) NSArray<NSArray *> *optionsArray;
@property(nonatomic, copy) NSArray<NSString *> *valueArray;
@property(nonatomic, copy, nullable) NSString *placeholder;//drawn 70% gray
@property(nonatomic, copy, nullable) NSAttributedString *attributedPlaceholder;//default is nil
@property(nonatomic, readonly) NSArray<NSNumber *> *selectIndexArray;

@property(nonatomic, copy) void(^onValueChangeHandler)(DJTableViewVMPickerRow *rowVM);

- (id)initWithTitle:(NSString *)title value:(nullable NSArray<NSString *> *)valueArray placeholder:(NSString *)placeholder options:(NSArray<NSArray<NSString *> *> *)optionsArray;
- (id)initWithTitle:(NSString *)title protocolValue:(nullable NSArray<DJValueProtocol> *)originalValueArray placeholder:(NSString *)placeholder protocolOptions:(NSArray<NSArray<DJValueProtocol> *> *)optionsArray;

@end

NS_ASSUME_NONNULL_END
