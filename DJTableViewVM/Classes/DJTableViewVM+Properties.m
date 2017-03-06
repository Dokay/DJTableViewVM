//
//  DJTableViewVM+Properties.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/9/19.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJTableViewVM+Properties.h"

@implementation DJTableViewVM (Properties)

#pragma mark - UITableView properties

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    NSArray *seletorArray = @[@"setRowHeight:",@"rowHeight",
                              @"setSectionFooterHeight:",@"sectionFooterHeight",
                              @"setEstimatedRowHeight:",@"estimatedRowHeight",
                              @"setEstimatedSectionHeaderHeight:",@"estimatedSectionHeaderHeight",
                              @"setEstimatedSectionFooterHeight:",@"estimatedSectionFooterHeight",
                              @"setSeparatorInset:",@"separatorInset",
                              @"setSeparatorColor:",@"separatorColor",
                              @"setTableHeaderView:",@"tableHeaderView",
                              @"setTableFooterView:",@"tableFooterView",
                              @"setBackgroundView:",@"backgroundView",
                              @"setSectionHeaderHeight:",@"sectionHeaderHeight"];
    
    if ([seletorArray containsObject:NSStringFromSelector(aSelector)]) {
        return self.tableView;
    }else{
        return [super forwardingTargetForSelector:aSelector];
    }
}



@end
