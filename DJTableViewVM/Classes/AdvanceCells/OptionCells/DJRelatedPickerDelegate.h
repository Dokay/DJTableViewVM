//
//  DJRelatedPickerDelegate.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJPickerProtocol.h"
#import "DJValueProtocol.h"

@interface DJRelatedPickerDelegate : NSObject<DJPickerProtocol>

@property(nonatomic, weak) UIPickerView *pickerView;
@property(nonatomic, strong) UIColor *pickerTitleColor;
@property(nonatomic, strong) UIFont *pickerTitleFont;
@property(nonatomic, copy) CGFloat(^widthForComponent)(NSInteger component);
@property(nonatomic, copy) CGFloat(^heightForComponent)(NSInteger component);
@property(nonatomic, copy) void(^valueChangeBlock)(NSArray *valuesArray);

- (instancetype)initWithOptions:(NSArray<NSObject<DJRelatedPickerValueProtocol> *> *)optionsArray;
- (NSArray *)selectedObjects;

@end
