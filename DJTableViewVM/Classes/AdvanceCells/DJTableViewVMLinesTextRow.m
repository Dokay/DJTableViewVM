//
//  DJTableViewVMLinesTextRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMLinesTextRow.h"

@implementation DJTableViewVMLinesTextRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.heightCaculateType = DJCellHeightCaculateAutoLayout;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
    }
    return self;
}

@end
