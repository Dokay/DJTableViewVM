//
//  DJRevealViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2019/5/26.
//  Copyright © 2019 dj226. All rights reserved.
//

#import "DJRevealViewController.h"

@interface DJRevealViewController ()

@property (nonatomic, strong) DJTableViewVM *revealTableViewVM;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DJRevealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"DJTableViewVM Reveal";
    
    [self setupView];
    
    [self showRevealView];
}

- (void)setupView{
    [self.view addSubview:self.tableView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
}

- (void)showRevealView{
    
    if (self.tableViewVM.tableHeaderView) {
        self.revealTableViewVM.tableHeaderView = [self customViewWithPosition:[NSString stringWithFormat:@"TableView Header: %@",NSStringFromClass(self.tableViewVM.tableHeaderView.class)] frame:self.tableViewVM.tableHeaderView.frame];
    }
    
    if (self.tableViewVM.tableFooterView) {
        self.revealTableViewVM.tableFooterView = [self customViewWithPosition:[NSString stringWithFormat:@"TableView Footer: %@",NSStringFromClass(self.tableViewVM.tableFooterView.class)] frame:self.tableViewVM.tableFooterView.frame];
    }
    
    [self.revealTableViewVM removeAllSections];
    
    for (DJTableViewVMSection *sectionVM in self.tableViewVM.sections) {
        DJTableViewVMSection *revealSection = [DJTableViewVMSection new];
        
        if (sectionVM.headerView) {
            self.revealTableViewVM.tableHeaderView = [self customViewWithPosition:[NSString stringWithFormat:@"Section Header: %@",NSStringFromClass(sectionVM.headerView.class)] frame:sectionVM.headerView.frame];
        }
        
        if (sectionVM.footerView) {
            self.revealTableViewVM.tableFooterView = [self customViewWithPosition:[NSString stringWithFormat:@"Section Footer: %@",NSStringFromClass(sectionVM.footerView.class)] frame:sectionVM.footerView.frame];
        }
        
        for (DJTableViewVMRow *rowVM in sectionVM.rows) {
            DJTableViewVMRow *revealRow = [DJTableViewVMRow new];
            revealRow.title = [rowVM rowDebugInfo];
            revealRow.cellHeight = rowVM.cellHeight;
            revealRow.separatorLineType = rowVM.separatorLineType;
            revealRow.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
            [revealRow setSelectionHandler:^(id  _Nonnull rowVM) {
                //just to avoid reveal recursive
            }];
            [revealSection addRow:revealRow];
        }
        [self.revealTableViewVM addSection:revealSection];
    }
    
    [self.revealTableViewVM reloadData];
}

- (UIView *)customViewWithPosition:(NSString *)position frame:(CGRect)frame{
    UIView *positionView = [[UIView alloc] initWithFrame:frame];
    
    CGFloat fontSize = 16;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (frame.size.height-fontSize)/2, frame.size.width, fontSize)];
    label.text = position;
    label.font = [UIFont systemFontOfSize:fontSize];
    
    [positionView addSubview:label];
    
    return positionView;
}

#pragma - getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}

- (DJTableViewVM *)revealTableViewVM
{
    if (_revealTableViewVM== nil) {
        _revealTableViewVM = [[DJTableViewVM alloc] initWithTableView:self.tableView];
    }
    return _revealTableViewVM;
}

@end
