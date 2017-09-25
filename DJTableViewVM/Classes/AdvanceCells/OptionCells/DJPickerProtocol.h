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
@property(nonatomic, weak) UIPickerView *pickerView;
@property(nonatomic, strong) UIColor *pickerTitleColor;
@property(nonatomic, strong) UIFont *pickerTitleFont;
@property(nonatomic, copy) CGFloat(^widthForComponent)(NSInteger component);
@property(nonatomic, copy) CGFloat(^heightForComponent)(NSInteger component);
@property(nonatomic, copy) void(^valueChangeBlock)(NSArray *valuesArray);

- (void)refreshPickerWithValues:(NSArray *)valuesArray;
- (NSArray *)selectedObjects;

@end
