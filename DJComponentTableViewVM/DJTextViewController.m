//
//  DJTextViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/17.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTextViewController.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMTextFieldCell.h"
#import "DJTableViewVMTextViewCell.h"
#import "DJTableViewVM+Keyboard.h"

@interface DJTextViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *tableViewVM;

@property (nonatomic, strong) DJTableViewVMTextFieldCellRow *textFieldRow;
@property (nonatomic, strong) DJTableViewVMTextViewCellRow *textViewRow;

@end

@implementation DJTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self registCells];
    [self configTable];
}

- (void)registCells
{
    DJTableViewRegister(self.tableViewVM, DJTableViewVMTextFieldCellRow, DJTableViewVMTextFieldCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMTextViewCellRow, DJTableViewVMTextViewCell);
}

- (void)configTable
{
    [self.tableViewVM removeAllSections];
    
    DJTableViewVMSection *textTestSection = [DJTableViewVMSection new];
    [self.tableViewVM addSection:textTestSection];
    
    for (NSInteger i = 0; i < 7; i++) {
        DJTableViewVMRow *rowVM = [DJTableViewVMRow new];
        rowVM.cellHeight = 50;
        rowVM.title = [NSString stringWithFormat:@"%@",@(i)];
        [textTestSection addRow:rowVM];
    }
    
    [textTestSection addRow:self.textFieldRow];
    [textTestSection addRow:self.textViewRow];
    
    for (NSInteger i = 10; i < 13; i++) {
        DJTableViewVMRow *rowVM = [DJTableViewVMRow new];
        rowVM.cellHeight = 50;
        rowVM.title = [NSString stringWithFormat:@"%@",@(i)];
        [textTestSection addRow:rowVM];
    }
    
    [self.tableViewVM reloadData];
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _tableView;
}

- (DJTableViewVM *)tableViewVM
{
    if (_tableViewVM == nil) {
        _tableViewVM = [[DJTableViewVM alloc] initWithTableView:self.tableView];
        _tableViewVM.emptyLinesHide = YES;
        _tableViewVM.keyboardManageEnabled = YES;
        _tableViewVM.scrollHideKeyboadEnable = YES;
        _tableViewVM.tapHideKeyboardEnable = YES;
    }
    return _tableViewVM;
}

- (DJTableViewVMTextFieldCellRow *)textFieldRow
{
    if (_textFieldRow == nil) {
        _textFieldRow = [DJTableViewVMTextFieldCellRow new];
        _textFieldRow.font = [UIFont systemFontOfSize:20];
        _textFieldRow.placeholder = @"Please input your name";
        _textFieldRow.charactersMaxCount = 8;
        [_textFieldRow setTextChanged:^(DJTableViewVMTextFieldCellRow * _Nonnull rowVM) {
            NSLog(@"input->message:%@",rowVM.text);
        }];
        [_textFieldRow setMaxCountInputMore:^(DJTableViewVMTextFieldCellRow * _Nonnull rowVM) {
            NSLog(@"more than 8");
        }];
        _textFieldRow.title = @"Name：";
        
    }
    return _textFieldRow;
}

- (DJTableViewVMTextViewCellRow *)textViewRow
{
    if (_textViewRow == nil) {
        _textViewRow = [DJTableViewVMTextViewCellRow new];
        _textViewRow.placeholder = @"Please input your address";
        _textViewRow.showCharactersCount = YES;
    }
    return _textViewRow;
}

@end
