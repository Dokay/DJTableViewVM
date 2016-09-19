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
- (void)setRowHeight:(CGFloat)rowHeight
{
    self.tableView.rowHeight = rowHeight;
}

- (CGFloat)rowHeight
{
    return self.tableView.rowHeight;
}

- (void)setSectionFooterHeight:(CGFloat)sectionFooterHeight
{
    self.tableView.sectionFooterHeight = sectionFooterHeight;
}

- (CGFloat)sectionFooterHeight
{
    return self.tableView.sectionFooterHeight;
}

- (void)setSectionHeaderHeight:(CGFloat)sectionHeaderHeight
{
    self.tableView.sectionHeaderHeight = sectionHeaderHeight;
}

- (CGFloat)sectionHeaderHeight
{
    return self.tableView.sectionHeaderHeight;
}

- (void)setEstimatedRowHeight:(CGFloat)estimatedRowHeight
{
    self.tableView.estimatedRowHeight = estimatedRowHeight;
}

- (CGFloat)estimatedRowHeight
{
    return self.tableView.estimatedRowHeight;
}

- (void)setEstimatedSectionHeaderHeight:(CGFloat)estimatedSectionHeaderHeight
{
    self.tableView.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight;
}

- (CGFloat)estimatedSectionHeaderHeight
{
    return self.tableView.estimatedSectionHeaderHeight;
}

- (void)setEstimatedSectionFooterHeight:(CGFloat)estimatedSectionFooterHeight
{
    self.tableView.estimatedSectionFooterHeight = estimatedSectionFooterHeight;
}

- (CGFloat)estimatedSectionFooterHeight
{
    return self.tableView.estimatedSectionFooterHeight;
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset
{
    self.tableView.separatorInset = separatorInset;
}

- (UIEdgeInsets)separatorInset
{
    return self.tableView.separatorInset;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    self.tableView.separatorColor = separatorColor;
}

- (UIColor *)separatorColor
{
    return self.tableView.separatorColor;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    self.tableView.tableHeaderView = tableHeaderView;
}

- (UIView *)tableHeaderView
{
    return self.tableView.tableHeaderView;
}

- (void)setTableFooterView:(UIView *)tableFooterView
{
    self.tableView.tableFooterView = tableFooterView;
}

- (UIView *)tableFooterView
{
    return self.tableView.tableFooterView;
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    self.tableView.backgroundView = backgroundView;
}

- (UIView *)backgroundView
{
    return self.tableView.backgroundView;
}

@end
