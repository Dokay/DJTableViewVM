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
#import "DJTableViewVMBoolCell.h"
#import "DJLog.h"
#import "DJTableViewVMOptionRow.h"
#import "DJTableViewVMOptionsController.h"

@interface DJAdvanceViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *tableViewVM;

@property (nonatomic, strong) DJTableViewVMBoolRow *boolRow;
@property (nonatomic, strong) DJMultipleLineTextRow *multipleLineRow;
@property (nonatomic, strong) DJTableViewVMOptionRow *optionRow;
@property (nonatomic, strong) DJTableViewVMOptionRow *multipleChoiceRow;


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
    DJTableViewRegister(self.tableViewVM, DJTableViewVMBoolRow, DJTableViewVMBoolCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMOptionRow, DJTableViewVMCell)
}

- (void)configTable
{
    [self.tableViewVM removeAllSections];
    
    DJTableViewVMSection *testSection = [DJTableViewVMSection new];
    [self.tableViewVM addSection:testSection];
    
    [testSection addRow:self.boolRow];
    [testSection addRow:self.multipleLineRow];
    [testSection addRow:self.optionRow];
    [testSection addRow:self.multipleChoiceRow];
    
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

- (DJTableViewVMBoolRow *)boolRow
{
    if (_boolRow == nil) {
        _boolRow = [[DJTableViewVMBoolRow alloc] initWithTitle:@"Switch" value:NO valueChangeHander:^(DJTableViewVMBoolRow *rowVM) {
            DJLog(@"value :%d",rowVM.value);
        }];
    }
    return _boolRow;
}

- (DJMultipleLineTextRow *)multipleLineRow
{
    if (_multipleLineRow == nil) {
        _multipleLineRow = [DJMultipleLineTextRow new];
        _multipleLineRow.text = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.";
        _multipleLineRow.titleFont = [UIFont systemFontOfSize:17];
    }
    return _multipleLineRow;
}

- (DJTableViewVMOptionRow *)optionRow
{
    if (_optionRow == nil) {
        _optionRow = [[DJTableViewVMOptionRow alloc] initWithTitle:@"Option" value:@"Value 4" selectionHandler:^(DJTableViewVMOptionRow *rowVM) {
            [rowVM deselectRowAnimated:YES];
            
            NSMutableArray *options = [NSMutableArray new];
            for (NSInteger i = 0; i < 10; i++) {
                [options addObject:[NSString stringWithFormat:@"Value %@",@(i)]];
            }
            
            __weak typeof(self) weakSelf = self;
            DJTableViewVMOptionsController *optionsConttroller = [[DJTableViewVMOptionsController alloc] initWithRow:rowVM options:options multipleChoice:NO completionHandler:^(NSString *selectValue) {
                rowVM.value = selectValue;
                [rowVM reloadRowWithAnimation:UITableViewRowAnimationNone];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:optionsConttroller animated:YES];
        }];
    }
    return _optionRow;
}

- (DJTableViewVMOptionRow *)multipleChoiceRow
{
    if (_multipleChoiceRow == nil) {
        _multipleChoiceRow = [[DJTableViewVMOptionRow alloc] initWithTitle:@"Multiple Option" value:@"Value 4,Value 5" selectionHandler:^(DJTableViewVMOptionRow *rowVM) {
            [rowVM deselectRowAnimated:YES];
            
            NSMutableArray *options = [NSMutableArray new];
            for (NSInteger i = 0; i < 10; i++) {
                [options addObject:[NSString stringWithFormat:@"Value %@",@(i)]];
            }
            
            __weak typeof(self) weakSelf = self;
            DJTableViewVMOptionsController *optionsConttroller = [[DJTableViewVMOptionsController alloc] initWithRow:rowVM options:options multipleChoice:YES completionHandler:^(NSString *selectValue) {
                rowVM.value = selectValue;
                [rowVM reloadRowWithAnimation:UITableViewRowAnimationNone];
            }];
            optionsConttroller.rightButtonTitle = @"OK";
            [optionsConttroller setRightButtonClickHandler:^(NSString *selectValue){
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [self.navigationController pushViewController:optionsConttroller animated:YES];
        }];
    }
    return _multipleChoiceRow;
}


@end
