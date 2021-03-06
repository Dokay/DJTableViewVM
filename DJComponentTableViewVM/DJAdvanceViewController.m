//
//  DJAdvanceViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJAdvanceViewController.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMLinesTextCell.h"
#import "DJTableViewVMBoolCell.h"
#import "DJLog.h"
#import "DJTableViewVMOptionRow.h"
#import "DJTableViewVMOptionsController.h"
#import "DJTableViewVMSegmentedCell.h"
#import "DJTableViewVMPickerCell.h"
#import "DJTableViewVMDateCell.h"
#import "DJPickerValueModel.h"
#import "DJReplatedPickerModel.h"

@interface DJAdvanceViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *tableViewVM;

@property (nonatomic, strong) DJTableViewVMBoolRow *boolRow;
@property (nonatomic, strong) DJTableViewVMLinesTextRow *multipleLineRow;
@property (nonatomic, strong) DJTableViewVMOptionRow *optionRow;
@property (nonatomic, strong) DJTableViewVMOptionRow *multipleChoiceRow;
@property (nonatomic, strong) DJTableViewVMSegmentedRow *segmentRow;
@property (nonatomic, strong) DJTableViewVMPickerRow *pickerRow;
@property (nonatomic, strong) DJTableViewVMPickerRow *protocolPickerRow;
@property (nonatomic, strong) DJTableViewVMPickerRow *relatedPickerRow;
@property (nonatomic, strong) DJTableViewVMDateRow *dateRow;


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
    DJTableViewRegister(self.tableViewVM, DJTableViewVMLinesTextRow, DJTableViewVMLinesTextCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMBoolRow, DJTableViewVMBoolCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMOptionRow, DJTableViewVMCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMSegmentedRow, DJTableViewVMSegmentedCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMPickerRow, DJTableViewVMPickerCell);
    DJTableViewRegister(self.tableViewVM, DJTableViewVMDateRow, DJTableViewVMDateCell);
}

- (void)configTable
{
    [self.tableViewVM removeAllSections];
    
    DJTableViewVMSection *testSection = [DJTableViewVMSection new];
    [self.tableViewVM addSection:testSection];
    
    
    [testSection addRow:self.boolRow];
    [testSection addRow:self.multipleLineRow];
    [testSection addRow:self.dateRow];
    [testSection addRow:self.pickerRow];
    [testSection addRow:self.protocolPickerRow];
    [testSection addRow:self.relatedPickerRow];
    [testSection addRow:self.optionRow];
    [testSection addRow:self.multipleChoiceRow];
    [testSection addRow:self.segmentRow];
    
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
        _tableViewVM.keyboardManageEnabled = YES;
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

- (DJTableViewVMLinesTextRow *)multipleLineRow
{
    if (_multipleLineRow == nil) {
        _multipleLineRow = [DJTableViewVMLinesTextRow new];
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

- (DJTableViewVMSegmentedRow *)segmentRow
{
    if (_segmentRow == nil) {
        _segmentRow = [[DJTableViewVMSegmentedRow alloc] initWithTitle:@"Segmented" segmentedControlTitles:@[@"Segment 1",@"Segment 2"] index:0 switchValueChangeHandler:^(DJTableViewVMSegmentedRow *rowVM) {
            DJLog(@"index :%d",rowVM.selectIndex);
        }];
    }
    return _segmentRow;
}

- (DJTableViewVMPickerRow *)pickerRow
{
    if (_pickerRow == nil) {
        NSMutableArray *options = [NSMutableArray new];
        for (NSInteger i = 0; i < 10; i++) {
            [options addObject:[NSString stringWithFormat:@"Picker %@",@(i)]];
        }
        _pickerRow = [[DJTableViewVMPickerRow alloc] initWithTitle:@"Picker" value:@[@"Picker 1",@"Picker 3"] placeholder:@"please select" options:@[options.copy,options.copy]];
        [_pickerRow setOnValueChangeHandler:^(DJTableViewVMPickerRow *rowVM){
            DJLog(@"values:%@",rowVM.valueArray);
            DJLog(@"select obj:%@",rowVM.selectedObjectsArray);
        }];
    }
    return _pickerRow;
}

- (DJTableViewVMPickerRow *)protocolPickerRow
{
    if (_protocolPickerRow == nil) {
        NSMutableArray *optionsArray = [NSMutableArray arrayWithCapacity:10];
        for (NSInteger i = 0; i < 10; i++) {
            DJPickerValueModel *valueModel = [DJPickerValueModel new];
            valueModel.ID = i;
            valueModel.pickerTitle = [NSString stringWithFormat:@"Picker %@",@(i)];
            [optionsArray addObject:valueModel];
        }
        _protocolPickerRow = [[DJTableViewVMPickerRow alloc] initWithTitle:@"Protocol Picker" value:@[@"Picker 1",@"Picker 3"] placeholder:@"please select" protocolOptions:@[optionsArray.copy,optionsArray.copy]];
        [_protocolPickerRow setHeightForComponent:^CGFloat(NSInteger component){
            return 50;
        }];
        [_protocolPickerRow setOnValueChangeHandler:^(DJTableViewVMPickerRow *rowVM){
            DJLog(@"values:%@",rowVM.valueArray);
            DJLog(@"select obj:%@",rowVM.selectedObjectsArray);
        }];
    }
    return _protocolPickerRow;
}

- (DJTableViewVMPickerRow *)relatedPickerRow
{
    if (_relatedPickerRow == nil) {
        NSMutableArray *optionsArray = [DJReplatedPickerModel buildRelatedDeep:3 lastTag:@"0"].copy;
        
        _relatedPickerRow = [[DJTableViewVMPickerRow alloc] initWithTitle:@"Related Picker" value:@[@"0 3",@"0 3 6",@"0 3 6 3"] placeholder:@"please select" relatedOptions:optionsArray.copy];
        _relatedPickerRow.pickerTitleColor = [UIColor purpleColor];
        _relatedPickerRow.pickerTitleFont = [UIFont systemFontOfSize:30];
        [_relatedPickerRow setWidthForComponent:^CGFloat(NSInteger component){
            if (component == 2) {
                return 140;
            }else{
                return ([UIScreen mainScreen].bounds.size.width - 140)/2;
            }
        }];
        [_relatedPickerRow setHeightForComponent:^CGFloat(NSInteger component){
            return 50;
        }];
        [_relatedPickerRow setOnValueChangeHandler:^(DJTableViewVMPickerRow *rowVM){
            DJLog(@"values:%@",rowVM.valueArray);
            DJLog(@"select obj:%@",rowVM.selectedObjectsArray);
        }];
    }
    return _relatedPickerRow;
}

- (DJTableViewVMDateRow *)dateRow
{
    if (_dateRow == nil) {
        _dateRow = [[DJTableViewVMDateRow alloc] initWithTitle:@"Date Picker" date:[NSDate date] placeholder:@"please select" format:@"yyyy-MM-dd" datePickerMode:UIDatePickerModeDate];
    }
    return _dateRow;
}


@end
