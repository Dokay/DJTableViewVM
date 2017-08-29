//
//  DJTableViewVMOptionRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMOptionRow.h"
#import "DJTableViewVM.h"

@implementation DJTableViewVMOptionRow

- (id)initWithTitle:(NSString *)title value:(NSString *)value selectionHandler:(void(^)(DJTableViewVMOptionRow *rowVM))selectionHandler
{
    self = [super init];
    if (self) {
        self.title = title;
        self.value = value;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.style = UITableViewCellStyleValue1;
        self.elementEdge = UIEdgeInsetsMake(self.elementEdge.top, self.elementEdge.left, self.elementEdge.bottom, 0);
        
        [self setSelectionHandler:^(DJTableViewVMOptionRow *rowVM){
            [rowVM.sectionVM.tableViewVM.tableView endEditing:YES];
            if (selectionHandler) {
                selectionHandler(rowVM);
            }
        }];
    }
    return self;
}

- (void)setValue:(NSString *)value
{
    _value = value;
    self.detailText = value;
}

@end
