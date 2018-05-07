//
//  DJInputCellTestController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/2/17.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJInputCellTestController.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMTextFieldCell.h"
#import "DJTableViewVMTextViewCell.h"
#import "DJTableViewVM+Keyboard.h"
#import "DJLog.h"

@interface DJInputCellTestController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *tableViewVM;

@property (nonatomic, strong) DJTableViewVMTextFieldRow *textFieldHeaderRow;
@property (nonatomic, strong) DJTableViewVMTextViewRow *textViewHeaderRow;
@property (nonatomic, strong) DJTableViewVMTextFieldRow *textFieldMiddleRow;
@property (nonatomic, strong) DJTableViewVMTextViewRow *textViewMiddleRow;
@property (nonatomic, strong) DJTableViewVMTextFieldRow *textFieldFooterRow;
@property (nonatomic, strong) DJTableViewVMTextViewRow *textViewFooterRow;

@end

@implementation DJInputCellTestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Input Test";
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self registCells];
    [self configTable];
}

- (void)registCells
{
    DJTableViewRegister(self.tableViewVM, DJTableViewVMTextFieldRow, DJTableViewVMTextFieldCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMTextViewRow, DJTableViewVMTextViewCell);
}

- (void)configTable
{
    [self.tableViewVM removeAllSections];
    
    DJTableViewVMSection *inputTestSection = [DJTableViewVMSection new];
    [self.tableViewVM addSection:inputTestSection];
    
    [inputTestSection addRow:self.textViewHeaderRow];
    [inputTestSection addRow:self.textFieldHeaderRow];
    
    for (NSInteger i = 0; i < 5; i++) {
        DJTableViewVMRow *rowVM = [DJTableViewVMRow new];
        rowVM.cellHeight = 50;
        rowVM.title = [NSString stringWithFormat:@"%@",@(i)];
        [inputTestSection addRow:rowVM];
    }
    
    [inputTestSection addRow:self.textFieldMiddleRow];
    [inputTestSection addRow:self.textViewMiddleRow];
    
    for (NSInteger i = 10; i < 13; i++) {
        DJTableViewVMRow *rowVM = [DJTableViewVMRow new];
        rowVM.cellHeight = 50;
        rowVM.title = [NSString stringWithFormat:@"%@",@(i)];
        [inputTestSection addRow:rowVM];
    }
    
    [inputTestSection addRow:self.textFieldFooterRow];
    [inputTestSection addRow:self.textViewFooterRow];
    
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
        _tableViewVM.keyboardManageEnabled = YES;
        _tableViewVM.tapHideKeyboardEnable = YES;
        _tableViewVM.scrollHideKeyboadEnable = YES;
    }
    return _tableViewVM;
}

- (DJTableViewVMTextFieldRow *)textFieldHeaderRow
{
    if (_textFieldHeaderRow == nil) {
        _textFieldHeaderRow = [DJTableViewVMTextFieldRow new];
        _textFieldHeaderRow.font = [UIFont systemFontOfSize:20];
        _textFieldHeaderRow.placeholder = @"Please input your name";
        _textFieldHeaderRow.charactersMaxCount = 8;
        [_textFieldHeaderRow setTextChanged:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            DJLog(@"input->message:%@",rowVM.text);
        }];
        [_textFieldHeaderRow setMaxCountInputMore:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            DJLog(@"more than 8");
        }];
        _textFieldHeaderRow.title = @"Name: ";
    }
    return _textFieldHeaderRow;
}

- (DJTableViewVMTextViewRow *)textViewHeaderRow
{
    if (_textViewHeaderRow == nil) {
        _textViewHeaderRow = [DJTableViewVMTextViewRow new];
        _textViewHeaderRow.placeholder = @"Please input your address";
        _textViewHeaderRow.showCharactersCount = YES;
        _textViewHeaderRow.focusScrollPosition = UITableViewScrollPositionBottom;
        _textViewHeaderRow.charactersMaxCount = 200;
    }
    return _textViewHeaderRow;
}

- (DJTableViewVMTextFieldRow *)textFieldMiddleRow
{
    if (_textFieldMiddleRow == nil) {
        _textFieldMiddleRow = [DJTableViewVMTextFieldRow new];
        _textFieldMiddleRow.font = [UIFont systemFontOfSize:20];
        _textFieldMiddleRow.placeholder = @"Please input your name";
        _textFieldMiddleRow.charactersMaxCount = 8;
        [_textFieldMiddleRow setTextChanged:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            DJLog(@"input->message:%@",rowVM.text);
        }];
        [_textFieldMiddleRow setMaxCountInputMore:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            DJLog(@"more than 8");
        }];
        _textFieldMiddleRow.title = @"Name: ";
    }
    return _textFieldMiddleRow;
}

- (DJTableViewVMTextViewRow *)textViewMiddleRow
{
    if (_textViewMiddleRow == nil) {
        _textViewMiddleRow = [DJTableViewVMTextViewRow new];
        _textViewMiddleRow.placeholder = @"Please input your address";
        _textViewMiddleRow.showCharactersCount = YES;
        _textViewMiddleRow.focusScrollPosition = UITableViewScrollPositionBottom;
        _textViewMiddleRow.charactersMaxCount = 200;
        _textViewMiddleRow.cellHeight = 80;
    }
    return _textViewMiddleRow;
}

- (DJTableViewVMTextFieldRow *)textFieldFooterRow
{
    if (_textFieldFooterRow == nil) {
        _textFieldFooterRow = [DJTableViewVMTextFieldRow new];
        _textFieldFooterRow.font = [UIFont systemFontOfSize:20];
        _textFieldFooterRow.placeholder = @"Please input your name";
        _textFieldFooterRow.charactersMaxCount = 8;
        [_textFieldFooterRow setTextChanged:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            DJLog(@"input->message:%@",rowVM.text);
        }];
        [_textFieldFooterRow setMaxCountInputMore:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            DJLog(@"more than 8");
        }];
        _textFieldFooterRow.title = @"Name: ";
    }
    return _textFieldFooterRow;
}

- (DJTableViewVMTextViewRow *)textViewFooterRow
{
    if (_textViewFooterRow == nil) {
        _textViewFooterRow = [DJTableViewVMTextViewRow new];
        _textViewFooterRow.placeholder = @"Please input your address";
        _textViewFooterRow.showCharactersCount = YES;
        _textViewFooterRow.focusScrollPosition = UITableViewScrollPositionBottom;
        _textViewFooterRow.charactersMaxCount = 200;
    }
    return _textViewFooterRow;
}

@end
