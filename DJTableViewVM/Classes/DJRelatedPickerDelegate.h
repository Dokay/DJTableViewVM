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

@property(nonatomic, copy) void(^valueChangeBlock)(NSArray *valuesArray);

- (instancetype)initWithOptions:(NSArray<NSArray<DJRelatedPickerValueProtocol> *> *)optionsArray pickerView:(UIPickerView *)pickerView;

//- (NSArray *)getValuesWithConponent:(NSInteger)component;
//- (NSString *)readValueObject:(NSObject *)valueObject;
//- (NSInteger)getComponentCount;

@end
