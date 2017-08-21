//
//  DJMultipleLineTextRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJMultipleLineTextRow.h"

@implementation DJMultipleLineTextRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightCaculateType = DJCellHeightCaculateAutoLayout;
        self.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.numberOfLines = 0;
    }
    return self;
}

@end
