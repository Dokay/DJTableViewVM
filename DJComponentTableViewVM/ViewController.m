//
//  ViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "ViewController.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMTextTestRow.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *aDJTableViewVM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    NSDictionary *views = NSDictionaryOfVariableBindings(_tableView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:views]];
    
    switch (self.type) {
        case 0:
        {
            [self testTable];
        }
            break;
        case 1:
        {
            [self testDefault];
        }
            break;
        case 2:
        {
            [self testTextRowAutoLayoutWithNib];
        }
            break;
        case 3:
        {
            [self testTextRowAutoLayoutWithOutNib];
        }
            break;
        case 4:
        {
            [self testTextRowFrameLayout];
        }
            break;
        default:
            break;
    }
}

- (void)testTable
{
    __weak ViewController *weakSelf = self;
    DJTableViewVMRow *simpleRow = [DJTableViewVMRow new];
    simpleRow.title = @"SimpleDemo";
    simpleRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [simpleRow setSelectionHandler:^(DJTableViewVMRow *rowVM) {
        [rowVM deselectRowAnimated:YES];
        ViewController *aViewController = [ViewController new];
        aViewController.type = 1;
        [weakSelf.navigationController pushViewController:aViewController animated:YES];
    }];
    
    DJTableViewVMRow *autoLayoutWithNibRow = [DJTableViewVMRow new];
    autoLayoutWithNibRow.title = @"AutoLayoutWithNibDemo";
    autoLayoutWithNibRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [autoLayoutWithNibRow setSelectionHandler:^(DJTableViewVMRow *rowVM) {
        [rowVM deselectRowAnimated:YES];
        ViewController *aViewController = [ViewController new];
        aViewController.type = 2;
        [weakSelf.navigationController pushViewController:aViewController animated:YES];
    }];
    
    DJTableViewVMRow *autoLayoutWithOutNibNibRow = [DJTableViewVMRow new];
    autoLayoutWithOutNibNibRow.title = @"AutoLayoutWithOutNibNibDemo";
    autoLayoutWithOutNibNibRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [autoLayoutWithOutNibNibRow setSelectionHandler:^(DJTableViewVMRow *rowVM) {
        [rowVM deselectRowAnimated:YES];
        ViewController *aViewController = [ViewController new];
        aViewController.type = 3;
        [weakSelf.navigationController pushViewController:aViewController animated:YES];
    }];
    
    DJTableViewVMRow *frameLayoutRow = [DJTableViewVMRow new];
    frameLayoutRow.title = @"FrameLayoutDemo";
    frameLayoutRow.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [frameLayoutRow setSelectionHandler:^(DJTableViewVMRow *rowVM) {
        [rowVM deselectRowAnimated:YES];
        ViewController *aViewController = [ViewController new];
        aViewController.type = 4;
        [weakSelf.navigationController pushViewController:aViewController animated:YES];
    }];
    
    [self.aDJTableViewVM removeAllSections];
    DJTableViewVMSection *contenteSection = [DJTableViewVMSection sectionWithHeaderHeight:0];
    [self.aDJTableViewVM addSection:contenteSection];
    [contenteSection addRow:simpleRow];
    [contenteSection addRow:autoLayoutWithNibRow];
    [contenteSection addRow:autoLayoutWithOutNibNibRow];
    [contenteSection addRow:frameLayoutRow];
    [self.tableView reloadData];
}

- (void)testTextRowAutoLayoutWithOutNib
{
    self.aDJTableViewVM[@"DJTableViewVMTextTestRow"] = @"DJTableViewVMTextAutoCell";
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithOutNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoLayout;
            row.contentText = @"gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985";
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testTextRowAutoLayoutWithNib
{
    self.aDJTableViewVM[@"DJTableViewVMTextTestRow"] = @"DJTableViewVMTextTestCell";
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoLayout;
            row.contentText = @"gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985";
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testTextRowFrameLayout
{
    self.aDJTableViewVM[@"DJTableViewVMTextTestRow"] = @"DJTableViewVMTextFrameCell";
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"FrameLayout"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoFrameLayout;
            row.contentText = [NSString stringWithFormat:@"%d--%d gshghseghsughsugseuigseugseugseugseuigseghseeihsgeihgisehogishegoieshgosei",j,i];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testDefault
{
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"Default"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMRow *row = [DJTableViewVMRow new];
            row.cellHeight = 70;
            if (i == 0) {
                row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            row.title = [NSString stringWithFormat:@"%d--%d",j,i];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - getter
- (DJTableViewVM *)aDJTableViewVM
{
    if (_aDJTableViewVM== nil) {
        _aDJTableViewVM= [[DJTableViewVM alloc] initWithTableView:self.tableView];
    }
    return _aDJTableViewVM;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}

@end
