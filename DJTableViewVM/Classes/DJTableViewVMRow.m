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
        self.detailTextFont = [DJTableViewVMRow defaultStyleInstance].detailTextFont;
        self.detailTextColor = [DJTableViewVMRow defaultStyleInstance].detailTextColor;
        self.backgroundColor = [DJTableViewVMRow defaultStyleInstance].backgroundColor;
        self.elementEdge = [DJTableViewVMRow defaultStyleInstance].elementEdge;
        self.titleTextAlignment = [DJTableViewVMRow defaultStyleInstance].titleTextAlignment;
        
        self.enabled = YES;
    }
    return self;
}

- (instancetype)initWithPlaceHolderColor:(UIColor *)color andHeight:(CGFloat)height
{
    self = [self init];
    if (self) {
        self.backgroundColor = color;
        self.cellHeight = height;
        self.separatorLineType = DJCellSeparatorLineHide;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (instancetype)rowWithPlaceHolderColor:(UIColor *)color andHeight:(CGFloat)height
{
    return [[self alloc] initWithPlaceHolderColor:color andHeight:height];
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
        self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor whiteColor];
        self.titleColor = [UIColor blackColor];
        self.titleFont = [UIFont systemFontOfSize:17];
        self.detailTextFont = [UIFont systemFontOfSize:17];
        self.detailTextColor = [UIColor colorWithWhite:0.3 alpha:0.7];
        self.backgroundColor = [UIColor whiteColor];
        self.elementEdge = UIEdgeInsetsMake(10, 15, 10, 15);
        self.titleTextAlignment = NSTextAlignmentLeft;
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
