//
//  DJTableViewVMSegmentedRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMSegmentedRow.h"


@implementation DJTableViewVMSegmentedRow

- (id)initWithTitle:(NSString *)title segmentedControlTitles:(NSArray<NSString *> *)titles index:(NSInteger)aIndex switchValueChangeHandler:(void(^)(DJTableViewVMSegmentedRow *rowVM))indexValueChangeHandler
{
    self = [super init];
    if (self) {
        self.title = title;
        _segmentedTitles = titles;
        _selectIndex = aIndex;
        _indexValueChangeHandler = indexValueChangeHandler;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title segmentedControlImages:(NSArray<UIImage *> *)images index:(NSInteger)aIndex switchValueChangeHandler:(void(^)(DJTableViewVMSegmentedRow *rowVM))indexValueChangeHandler
{
    self = [super init];
    if (self) {
        self.title = title;
        _segmentedImages = images;
        _selectIndex = aIndex;
        _indexValueChangeHandler = indexValueChangeHandler;
    }
    return self;
}

@end
