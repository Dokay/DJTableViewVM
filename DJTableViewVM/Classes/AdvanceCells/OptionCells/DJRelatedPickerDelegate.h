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
@property(nonatomic, copy) void(^valueChangeBlock)(NSArray *valuesArray);

- (instancetype)initWithOptions:(NSArray<NSObject<DJRelatedPickerValueProtocol> *> *)optionsArray;
- (NSArray *)selectedObjects;

@end
