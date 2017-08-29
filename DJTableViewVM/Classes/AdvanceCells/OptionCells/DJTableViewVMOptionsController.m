//
//  DJTableViewVMOptionsController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMOptionsController.h"
#import "DJTableViewVM.h"

@interface DJTableViewVMOptionsController ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) DJTableViewVM *tableViewVM;
@property(nonatomic, assign) BOOL multipleChoice;
@property(nonatomic, strong) NSString *originalValue;
@property(nonatomic, copy) NSArray *optionsArray;
@property(nonatomic, copy) void(^completionHandler)(NSString *selectValue);

@end

@implementation DJTableViewVMOptionsController

- (id)initWithRow:(DJTableViewVMOptionRow *)rowVM options:(NSArray<NSString *> *)optionsArray multipleChoice:(BOOL)multipleChoice completionHandler:(void(^)(NSString *selectValue))completionHandler
{
    self = [super init];
    if (self) {
        _completionHandler = completionHandler;
        _optionsArray = optionsArray;
        _multipleChoice = multipleChoice;
        _originalValue = rowVM.value;
        _separateCharater = @",";
        _tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.rightButtonTitle) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:self.rightButtonTitle style:UIBarButtonItemStyleDone target:self action:@selector(onTouchRightButton)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
    [self.view addSubview:self.tableView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tableView)]];
    
    [self configTable];
}

- (void)configTable
{
    DJTableViewVMSection *optionsSection = [DJTableViewVMSection sectionWithHeaderHeight:0];
    [self.tableViewVM addSection:optionsSection];
    
    NSArray *selectValues = [self.originalValue componentsSeparatedByString:self.separateCharater];
    __weak typeof(self) weakSelf = self;
    for (NSString *optionContent in self.optionsArray) {
        DJTableViewVMRow *optionRowVM = [DJTableViewVMRow new];
        optionRowVM.title = optionContent;
        if ([selectValues containsObject:optionContent]) {
            optionRowVM.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        [optionRowVM setSelectionHandler:^(DJTableViewVMRow *rowVM){
            [rowVM deselectRowAnimated:YES];
            if (weakSelf.multipleChoice == NO) {
                [weakSelf checkCellWithValue:rowVM.title];
                weakSelf.completionHandler(rowVM.title);
            }else{
                [weakSelf multipleCheckCellWithValue:rowVM.title];
                weakSelf.completionHandler([self readCurrentValue]);
            }
        }];
        
        [optionsSection addRow:optionRowVM];
    }
}

- (void)checkCellWithValue:(NSString *)value
{
    DJTableViewVMSection *optionsSection = self.tableViewVM.sections.firstObject;
    [optionsSection.rows enumerateObjectsUsingBlock:^(DJTableViewVMRow *  _Nonnull rowVM, NSUInteger idx, BOOL * _Nonnull stop) {
        if (rowVM.accessoryType == UITableViewCellAccessoryCheckmark && ![rowVM.title isEqualToString:value]) {
            rowVM.accessoryType = UITableViewCellAccessoryNone;
            [rowVM reloadRowWithAnimation:UITableViewRowAnimationNone];
        }
        
        if ([rowVM.title isEqualToString:value]) {
            rowVM.accessoryType = UITableViewCellAccessoryCheckmark;
            [rowVM reloadRowWithAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)multipleCheckCellWithValue:(NSString *)value
{
    DJTableViewVMSection *optionsSection = self.tableViewVM.sections.firstObject;
    [optionsSection.rows enumerateObjectsUsingBlock:^(DJTableViewVMRow *  _Nonnull rowVM, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if ([rowVM.title isEqualToString:value]) {
            if (rowVM.accessoryType == UITableViewCellAccessoryCheckmark) {
                rowVM.accessoryType = UITableViewCellAccessoryNone;
                [rowVM reloadRowWithAnimation:UITableViewRowAnimationNone];
            }else{
                rowVM.accessoryType = UITableViewCellAccessoryCheckmark;
                [rowVM reloadRowWithAnimation:UITableViewRowAnimationNone];
            }
        }
    }];
}

- (NSString *)readCurrentValue
{
    NSMutableString *selectValue = [NSMutableString new];
    DJTableViewVMSection *optionsSection = self.tableViewVM.sections.firstObject;
    [optionsSection.rows enumerateObjectsUsingBlock:^(DJTableViewVMRow *  _Nonnull rowVM, NSUInteger idx, BOOL * _Nonnull stop) {
        if (rowVM.accessoryType == UITableViewCellAccessoryCheckmark) {
            if (selectValue.length > 0) {
                [selectValue appendString:self.separateCharater];
            }
            [selectValue appendString:rowVM.title];
        }
    }];
    return selectValue.copy;
}

#pragma mark - actions
- (void)onTouchRightButton
{
    if (self.rightButtonClickHandler) {
        self.rightButtonClickHandler([self readCurrentValue]);
    }
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:self.tableViewStyle];
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


@end
