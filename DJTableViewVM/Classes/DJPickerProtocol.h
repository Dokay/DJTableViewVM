//
//  DJPickerProtocol.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/24.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@protocol DJPickerProtocol <UIPickerViewDelegate,UIPickerViewDataSource>

@required
@property(nonatomic, copy) void(^valueChangeBlock)(NSArray *valuesArray);

- (void)setSelectedWithValue:(NSArray *)valuesArray;

@end
