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

@interface DJTableViewVMRow()

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation DJTableViewVMRow

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.separatorInset = [DJTableViewVMRow defaultStyleInstance].separatorInset;
        self.selectionStyle = [DJTableViewVMRow defaultStyleInstance].selectionStyle;
        self.backgroundColor = [DJTableViewVMRow defaultStyleInstance].backgroundColor;
        self.titleColor = [DJTableViewVMRow defaultStyleInstance].titleColor;
        self.titleFont = [DJTableViewVMRow defaultStyleInstance].titleFont;
        self.detailTitleFont = [DJTableViewVMRow defaultStyleInstance].detailTitleFont;
        self.detailTitleColor = [DJTableViewVMRow defaultStyleInstance].detailTitleColor;
        self.backgroundColor = [DJTableViewVMRow defaultStyleInstance].backgroundColor;
        self.indentationLevel = [DJTableViewVMRow defaultStyleInstance].indentationLevel;
        self.indentationWidth = [DJTableViewVMRow defaultStyleInstance].indentationWidth;
        self.elementEdge = [DJTableViewVMRow defaultStyleInstance].elementEdge;
        
        self.enabled = YES;
    }
    return self;
}

+ (instancetype)defaultStyleInstance
{
    static id singleInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleInstance = [[self alloc] initDefaultStyle];
    });
    return singleInstance;
}

- (instancetype)initDefaultStyle
{
    self = [super init];
    if (self != nil){
        self.separatorInset = UIEdgeInsetsMake(CGFLOAT_MAX, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor whiteColor];
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:17];
        self.detailTitleFont = [UIFont systemFontOfSize:17];
        self.detailTitleColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        self.backgroundColor = [UIColor whiteColor];
        self.indentationLevel = 0;
        self.indentationWidth = 10;
        self.elementEdge = UIEdgeInsetsMake(10, 15, 10, 15);
    }
    return self;
}

+ (instancetype)row
{
    return [[self alloc] init];
}

- (NSIndexPath *)indexPath
{
    //using an instance _indexPath to make a strong reference in RowVM for param in DJLazyTask is weak.
    _indexPath = [NSIndexPath indexPathForRow:[self.sectionVM.rows indexOfObject:self] inSection:self.sectionVM.index];
    return _indexPath;
}

- (void)selectRowAnimated:(BOOL)animated
{
    [self selectRowAnimated:animated scrollPosition:UITableViewScrollPositionNone];
}

- (void)selectRowAnimated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition
{
    [self.sectionVM.tableViewVM.tableView selectRowAtIndexPath:self.indexPath animated:animated scrollPosition:scrollPosition];
}

- (void)deselectRowAnimated:(BOOL)animated
{
    [self.sectionVM.tableViewVM.tableView deselectRowAtIndexPath:self.indexPath animated:animated];
}

- (void)reloadRowWithAnimation:(UITableViewRowAnimation)animation
{
    [self.sectionVM.tableViewVM.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:animation];
}

- (void)deleteRowWithAnimation:(UITableViewRowAnimation)animation
{
    DJTableViewVMSection *section = self.sectionVM;
    NSInteger row = self.indexPath.row;
    [section removeRowAtIndex:self.indexPath.row];
    [section.tableViewVM.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:section.index]] withRowAnimation:animation];
}

@end
