//
//  DJReplatedPickerModel.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJReplatedPickerModel.h"

@implementation DJReplatedPickerModel

- (NSString *)dj_titleValue
{
    return _name;
}

- (NSArray *)dj_childOptionsValues
{
    return _pickerTitles;
}

+ (NSArray *)buildRelatedDeep:(NSInteger)deep lastTag:(NSString *)lastTag
{
    if (deep > 0) {
        deep--;
        NSMutableArray *tmpOptionsArray = [NSMutableArray arrayWithCapacity:10];
        for (NSInteger i = 0; i < 10; i++) {
            DJReplatedPickerModel *valueModel = [DJReplatedPickerModel new];
            valueModel.ID = i;
            valueModel.name = [NSString stringWithFormat:@"%@ %@",lastTag,@(i)];
            valueModel.pickerTitles = [self buildRelatedDeep:deep lastTag:valueModel.name];
            [tmpOptionsArray addObject:valueModel];
        }
        return tmpOptionsArray;
    }
    return nil;
}

@end
