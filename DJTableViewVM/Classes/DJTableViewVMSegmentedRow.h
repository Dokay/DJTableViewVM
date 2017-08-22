//
//  DJTableViewVMSegmentedRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>

@interface DJTableViewVMSegmentedRow : DJTableViewVMRow

@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, strong) UIColor *tintColor;
@property(nonatomic, copy) NSArray<NSString *> *segmentedTitles;
@property(nonatomic, copy) NSArray<UIImage *> *segmentedImages;
@property(nonatomic, copy) void(^indexValueChangeHandler)(DJTableViewVMSegmentedRow *rowVM);

- (id)initWithTitle:(NSString *)title segmentedControlTitles:(NSArray<NSString *> *)titles index:(NSInteger)aIndex switchValueChangeHandler:(void(^)(DJTableViewVMSegmentedRow *rowVM))indexValueChangeHandler;
- (id)initWithTitle:(NSString *)title segmentedControlImages:(NSArray<UIImage *> *)images index:(NSInteger)aIndex switchValueChangeHandler:(void(^)(DJTableViewVMSegmentedRow *rowVM))indexValueChangeHandler;

@end
