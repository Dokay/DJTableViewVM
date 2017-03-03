//
//  DJComponentTableViewVMRow.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVMRow.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMSection.h"

@implementation DJTableViewVMRow

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    self.cellHeight = 0;
    self.separatorInset = UIEdgeInsetsMake(CGFLOAT_MAX, 0, 0, 0);
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.backgroundColor = [UIColor whiteColor];
    self.indentationLevel = 0;
    self.indentationWidth = 10;
    self.titleColor = [UIColor blackColor];
    self.titleFont = [UIFont systemFontOfSize:17];

    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

+ (instancetype)row
{
    return [[self alloc] init];
}

- (NSIndexPath *)indexPath
{
    return [NSIndexPath indexPathForRow:[self.section.rows indexOfObject:self] inSection:self.section.index];
}

- (void)selectRowAnimated:(BOOL)animated
{
    [self selectRowAnimated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self.section.tableViewVM.tableView selectRowAtIndexPath:self.indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated
{
    [self.section.tableViewVM.tableView deselectRowAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation
{
    [self.section.tableViewVM.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}

- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation
{
    DJTableViewVMSection *section = self.section;
    NSInteger row = self.indexPath.row;
    [section removeRowAtIndex:self.indexPath.row];
    [section.tableViewVM.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.index]] withRowAnimation:animation];
}

@end
