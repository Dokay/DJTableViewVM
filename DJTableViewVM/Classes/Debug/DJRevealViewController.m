//
//  DJRevealViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2019/5/26.
//  Copyright © 2019 dj226. All rights reserved.
//

#import "DJRevealViewController.h"
#import "DJLog.h"

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
        NSString *postionInfo = [NSString stringWithFormat:@"Table header,%@%@,%@%@",kDJDebugClass,NSStringFromClass(self.tableViewVM.tableHeaderView.class),kDJDebugHeitht,@(self.tableViewVM.tableHeaderView.frame.size.height)];
        self.revealTableViewVM.tableHeaderView = [self customViewWithPosition:postionInfo frame:self.tableViewVM.tableHeaderView.frame];
    }
    
    if (self.tableViewVM.tableFooterView) {
        NSString *postionInfo = [NSString stringWithFormat:@"Table footer,%@%@,%@%@",kDJDebugClass,NSStringFromClass(self.tableViewVM.tableFooterView.class),kDJDebugHeitht,@(self.tableViewVM.tableFooterView.frame.size.height)];
        self.revealTableViewVM.tableFooterView = [self customViewWithPosition:postionInfo frame:self.tableViewVM.tableFooterView.frame];
    }
    
    [self.revealTableViewVM removeAllSections];
    
    for (DJTableViewVMSection *originalSectionVM in self.tableViewVM.sections) {
        DJTableViewVMSection *revealSection = [DJTableViewVMSection new];
        
        if (originalSectionVM.headerView) {
            revealSection.headerView = [self customViewWithPosition:[NSString stringWithFormat:@"Section header,%@ %@",kDJDebugClass,NSStringFromClass(originalSectionVM.headerView.class)] frame:originalSectionVM.headerView.frame];
        }
        
        if (originalSectionVM.footerView) {
            revealSection.footerView = [self customViewWithPosition:[NSString stringWithFormat:@"Section footer,%@ %@",kDJDebugClass,NSStringFromClass(originalSectionVM.footerView.class)] frame:originalSectionVM.footerView.frame];
        }
        
        if (revealSection.headerTitle.length > 0){
            NSString *postionInfo = [NSString stringWithFormat:@"Sectin header title:%@",originalSectionVM.headerTitle];
            revealSection.headerTitle = postionInfo;
        }
        
        if (revealSection.footerTitle.length > 0){
            NSString *postionInfo = [NSString stringWithFormat:@"Sectin footer title:%@",originalSectionVM.footerTitle];
            revealSection.footerTitle = postionInfo;
        }
        
        for (DJTableViewVMRow *rowVM in originalSectionVM.rows) {
            DJTableViewVMRow *revealRow = [DJTableViewVMRow new];
            revealRow.title = [rowVM rowDebugInfo];
            revealRow.cellHeight = rowVM.cellHeight;
            revealRow.selectionStyle = UITableViewRowAnimationNone;
            revealRow.separatorLineType = rowVM.separatorLineType;
            revealRow.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
            [revealRow setSelectionHandler:^(id  _Nonnull rowVM) {
                //avoid reveal recursive
            }];
            [revealSection addRow:revealRow];
        }
        [self.revealTableViewVM addSection:revealSection];
    }
    
    [self.revealTableViewVM reloadData];
}

- (UIView *)customViewWithPosition:(NSString *)positionInfo frame:(CGRect)frame{
    UIView *positionView = [[UIView alloc] initWithFrame:frame];
    
    CGFloat fontSize = 16;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, (frame.size.height-fontSize)/2, frame.size.width, fontSize)];
    label.text = positionInfo;
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
