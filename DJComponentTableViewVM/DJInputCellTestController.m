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

@interface DJInputCellTestController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *tableViewVM;

@property (nonatomic, strong) DJTableViewVMTextFieldRow *textFieldRow;
@property (nonatomic, strong) DJTableViewVMTextViewRow *textViewRow;

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
    
    DJTableViewVMSection *textTestSection = [DJTableViewVMSection new];
    [self.tableViewVM addSection:textTestSection];
    
    for (NSInteger i = 0; i < 5; i++) {
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
        _tableViewVM.keyboardManageEnabled = YES;
        _tableViewVM.tapHideKeyboardEnable = YES;
        _tableViewVM.scrollHideKeyboadEnable = YES;
    }
    return _tableViewVM;
}

- (DJTableViewVMTextFieldRow *)textFieldRow
{
    if (_textFieldRow == nil) {
        _textFieldRow = [DJTableViewVMTextFieldRow new];
        _textFieldRow.font = [UIFont systemFontOfSize:20];
        _textFieldRow.placeholder = @"Please input your name";
        _textFieldRow.charactersMaxCount = 8;
        [_textFieldRow setTextChanged:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            NSLog(@"input->message:%@",rowVM.text);
        }];
        [_textFieldRow setMaxCountInputMore:^(DJTableViewVMTextFieldRow * _Nonnull rowVM) {
            NSLog(@"more than 8");
        }];
        _textFieldRow.title = @"Name: ";
    }
    return _textFieldRow;
}

- (DJTableViewVMTextViewRow *)textViewRow
{
    if (_textViewRow == nil) {
        _textViewRow = [DJTableViewVMTextViewRow new];
        _textViewRow.placeholder = @"Please input your address";
        _textViewRow.showCharactersCount = YES;
        _textViewRow.focusScrollPosition = UITableViewScrollPositionTop;
        _textViewRow.charactersMaxCount = 200;
    }
    return _textViewRow;
}

@end
