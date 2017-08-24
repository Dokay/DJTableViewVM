//
//  DJNormalPickerDelegate.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJPickerProtocol.h"

@interface DJNormalPickerDelegate : NSObject<DJPickerProtocol>

@property(nonatomic, weak) UIPickerView *pickerView;
@property(nonatomic, copy) void(^valueChangeBlock)(NSArray *valuesArray);

- (instancetype)initWithOptions:(NSArray<NSArray *> *)optionsArray;


@end
