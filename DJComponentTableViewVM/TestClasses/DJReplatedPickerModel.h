//
//  DJReplatedPickerModel.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/25.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DJValueProtocol.h"

@interface DJReplatedPickerModel : NSObject<DJRelatedPickerValueProtocol>

@property(nonatomic, assign) NSInteger ID;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSArray *pickerTitles;

+ (NSArray *)buildRelatedDeep:(NSInteger)deep lastTag:(NSString *)lastTag;

#pragma mark - DJRelatedPickerValueProtocol
@property(nonatomic, copy, readonly) NSString *dj_titleValue;
@property(nonatomic, copy, readonly) NSArray *dj_childOptionsValues;

@end
