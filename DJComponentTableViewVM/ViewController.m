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
#import "DJAlertView.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *aDJTableViewVM;

@end

@implementation ViewController

#pragma mark - life
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
        case 5:
        {
            [self testMoveRow];
            [self.tableView setEditing:YES animated:YES];
        }
            break;
        case 6:
        {
            [self testPretch];
        }
            break;
        case 7:
        {
            [self testDelete];
        }
            break;
        case 8:
        {
            [self testEditActions];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tests
- (void)testTable
{
    NSArray *testDataSource = @[@{@"title":@"SimpleDemo",
                                  @"jumpID":@(1)},
                                @{@"title":@"AutoLayoutWithNibDemo",
                                  @"jumpID":@(2)},
                                @{@"title":@"AutoLayoutWithOutNibNibDemo",
                                  @"jumpID":@(3)},
                                @{@"title":@"FrameLayoutDemo",
                                  @"jumpID":@(4)},
                                @{@"title":@"MoveRowDemo",
                                  @"jumpID":@(5)},
                                @{@"title":@"PretchDemo",
                                  @"jumpID":@(6)},
                                @{@"title":@"DeleteDemo",
                                  @"jumpID":@(7)},
                                @{@"title":@"EditAction",
                                  @"jumpID":@(8)}];
    
    __weak ViewController *weakSelf = self;
    
    [self.aDJTableViewVM removeAllSections];
    DJTableViewVMSection *contenteSection = [DJTableViewVMSection sectionWithHeaderHeight:0];
    [self.aDJTableViewVM addSection:contenteSection];
    for (NSDictionary *testDic in testDataSource) {
        DJTableViewVMRow *testRowVM = [DJTableViewVMRow new];
        testRowVM.title = [testDic valueForKey:@"title"];
        testRowVM.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [testRowVM setSelectionHandler:^(DJTableViewVMRow *rowVM) {
            [rowVM deselectRowAnimated:YES];
            ViewController *aViewController = [ViewController new];
            aViewController.type = [[testDic objectForKey:@"jumpID"] integerValue];
            [weakSelf.navigationController pushViewController:aViewController animated:YES];
        }];
        [contenteSection addRow:testRowVM];
    }
    
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
            row.contentText = [NSString stringWithFormat:@"%d---%d,gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985",i,j];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
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
            row.contentText = [NSString stringWithFormat:@"%d---%d,gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985",i,j];;
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
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
            row.contentText = [NSString stringWithFormat:@"%d---%d,gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985",i,j];;
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
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
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testMoveRow
{
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"MoveRow"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 6; i ++) {
            DJTableViewVMRow *row = [DJTableViewVMRow new];
            row.cellHeight = 70;
            if (i == 0) {
                row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            }
            row.title = [NSString stringWithFormat:@"%d--%d",j,i];
            [row setMoveCellHandler:^BOOL(DJTableViewVMRow *rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) {
                return YES;
            }];
            [row setMoveCellCompletionHandler:^(DJTableViewVMRow *rowVM, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath) {
                NSLog(@"Move Complete");
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testPretch
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
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [row setPrefetchHander:^(DJTableViewVMRow *rowVM) {
                NSLog(@"PrefetchHander->%d--%d",j,i);
            }];
            [row setPrefetchCancelHander:^(DJTableViewVMRow *rowVM) {
                NSLog(@"PrefetchCancelHander->%d--%d",j,i);
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

- (void)testDelete
{
    [self.aDJTableViewVM removeAllSections];
    
    DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"delete"];
    [self.aDJTableViewVM addSection:section];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        if (i == 0) {
            row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        row.title = [NSString stringWithFormat:@"DeleteCell--%d",i];
        row.editingStyle = UITableViewCellEditingStyleDelete;
        [row setDeleteCellHandler:^(DJTableViewVMRow *rowVM) {
            NSLog(@"delete->--%d",i);
        }];
        [section addRow:row];
    }
    
    DJTableViewVMSection *completeSection = [DJTableViewVMSection sectionWithHeaderTitle:@"delete with complete bock"];
    [self.aDJTableViewVM addSection:completeSection];
    for (int i  = 0; i < 8; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        if (i == 0) {
            row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        row.title = [NSString stringWithFormat:@"DeleteCell--%d",i];
        row.editingStyle = UITableViewCellEditingStyleDelete;
        [row setDeleteCellHandler:^(DJTableViewVMRow *rowVM) {
            NSLog(@"delete->--%d",i);
        }];
        [row setDeleteCellCompleteHandler:^(DJTableViewVMRow *rowVM, void (^complete)()) {
            NSLog(@"delete %d with complete",i);
            DJAlertView *alertView = [[DJAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you want to delete rowVM \r\n with ID:%d?",i] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alertView showWithCompletion:^(DJAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    complete();
                }
            }];
        }];
        [completeSection addRow:row];
    }
    [self.tableView reloadData];
}

- (void)testEditActions
{
    DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"EditActions"];
    [self.aDJTableViewVM addSection:section];
    for (int i  = 0; i < 10; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        if (i == 0) {
            row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        row.title = [NSString stringWithFormat:@"EditActions--%d",i];
        row.editingStyle = UITableViewCellEditingStyleDelete;
        if (([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)) {
            UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"action 1" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                NSLog(@"action 1");
            }];
            action1.backgroundColor = [UIColor orangeColor];
            
            UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"action 2" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                NSLog(@"action 2");
            }];
            action2.backgroundColor = [UIColor purpleColor];
            row.editActions = @[action1,action2];
        }
        
        [section addRow:row];
    }
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
