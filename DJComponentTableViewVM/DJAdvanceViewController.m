//
//  DJAdvanceViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJAdvanceViewController.h"
#import "DJTableViewVM.h"
#import "DJMultipleLineTextCell.h"

@interface DJAdvanceViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *tableViewVM;

@property (nonatomic, strong) DJMultipleLineTextRow *multipleLineRow;

@end

@implementation DJAdvanceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Advance Test";
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self registCells];
    [self configTable];
}

- (void)registCells
{
    DJTableViewRegister(self.tableViewVM, DJMultipleLineTextRow, DJMultipleLineTextCell);
//    DJTableViewRegister(self.tableViewVM, DJTableViewVMTextViewRow, DJTableViewVMTextViewCell);
}

- (void)configTable
{
    [self.tableViewVM removeAllSections];
    
    DJTableViewVMSection *testSection = [DJTableViewVMSection new];
    [self.tableViewVM addSection:testSection];
    
    [testSection addRow:self.multipleLineRow];
    
//
//    for (NSInteger i = 0; i < 8; i++) {
//        DJTableViewVMRow *rowVM = [DJTableViewVMRow new];
//        rowVM.cellHeight = 50;
//        rowVM.title = [NSString stringWithFormat:@"%@",@(i)];
//        [textTestSection addRow:rowVM];
//    }
//    
//    [textTestSection addRow:self.textFieldRow];
//    [textTestSection addRow:self.textViewRow];
//    
//    for (NSInteger i = 10; i < 13; i++) {
//        DJTableViewVMRow *rowVM = [DJTableViewVMRow new];
//        rowVM.cellHeight = 50;
//        rowVM.title = [NSString stringWithFormat:@"%@",@(i)];
//        [textTestSection addRow:rowVM];
//    }
    
    [self.tableViewVM reloadData];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (DJTableViewVM *)tableViewVM
{
    if (_tableViewVM == nil) {
        _tableViewVM = [[DJTableViewVM alloc] initWithTableView:self.tableView];
    }
    return _tableViewVM;
}

- (DJMultipleLineTextRow *)multipleLineRow
{
    if (_multipleLineRow == nil) {
        _multipleLineRow = [DJMultipleLineTextRow new];
        _multipleLineRow.text = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.\n May you have enough happiness to make you sweet,enough trials to make you strong,enough sorrow to keep you human,enough hope to make you happy?";
        _multipleLineRow.titleFont = [UIFont systemFontOfSize:17];
    }
    return _multipleLineRow;
}


@end
