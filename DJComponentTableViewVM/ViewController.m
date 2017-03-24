//
//  ViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "ViewController.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMTextAutoCell.h"
#import "DJTableViewVMTextTestCell.h"
#import "DJTableViewVMTextFrameCell.h"
#import "DJAlertView.h"
#import "DJInputCellTestController.h"
#import "DJLog.h"

BOOL DJ_LOG_ENABLE = YES;

static const NSString *kConstContent = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.\n May you have enough happiness to make you sweet,enough trials to make you strong,enough sorrow to keep you human,enough hope to make you happy? Always put yourself in others’shoes.If you feel that it hurts you,it probably hurts the other person, too. \nThe happiest of people don’t necessarily have the best of everything;they just make the most of everything that comes along their way.Happiness lies for those who cry,those who hurt, those who have searched,and those who have tried,for only they can appreciate the importance of people. \n who have touched their lives.Love begins with a smile,grows with a kiss and ends with a tear.The brightest future will always be based on a forgotten past, you can’t go on well in lifeuntil you let go of your past failures and heartaches.\n When you were born,you were crying and everyone around you was smiling.Live your life so that when you die,you're the one who is smiling and everyone around you is crying.\n Please send this message to those people who mean something to you,to those who have touched your life in one way or another,to those who make you smile when you really need it,to those that make you see the brighter side of things when you are really down,to those who you want to let them know that you appreciate their friendship.And if you don’t, don’t worry,nothing bad will happen to you,you will just miss out on the opportunity to brighten someone’s day with this message.";

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
            [self testPrefetch];
        }
            break;
        case 7:
        {
            [self testDelete];
        }
            break;
        case 8:
        {
            [self testSlideActions];
        }
            break;
        case 9:
        {
            [self testInsert];
            [self.tableView setEditing:YES animated:YES];
        }
            break;
        case 10:
        {
            [self testIndexTitle];
        }
            break;
        case 11:
        {
            [self testLongTapActions];
        }
            break;
        case 12:
        {
            
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
                                @{@"title":@"PrefetchDemo",
                                  @"jumpID":@(6)},
                                @{@"title":@"DeleteDemo",
                                  @"jumpID":@(7)},
                                @{@"title":@"SlideAction",
                                  @"jumpID":@(8)},
                                @{@"title":@"InsertDemo",
                                  @"jumpID":@(9)},
                                @{@"title":@"IndexTitle",
                                  @"jumpID":@(10)},
                                @{@"title":@"LongTapActions",
                                  @"jumpID":@(11)},
                                @{@"title":@"TextInputDemo",
                                  @"jumpID":@(12)},];
    
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
            if ([rowVM.title isEqualToString:@"TextInputDemo"]) {
                DJInputCellTestController *aDJInputCellTestController = [DJInputCellTestController new];
                [self.navigationController pushViewController:aDJInputCellTestController animated:YES];
            }else{
                ViewController *aViewController = [ViewController new];
                aViewController.type = [[testDic objectForKey:@"jumpID"] integerValue];
                [weakSelf.navigationController pushViewController:aViewController animated:YES];
            }
        }];
        [contenteSection addRow:testRowVM];
    }
    
    [self.aDJTableViewVM reloadData];
}

- (void)testTextRowAutoLayoutWithOutNib
{
    DJTableViewRegister(self.aDJTableViewVM, DJTableViewVMTextTestRow, DJTableViewVMTextAutoCell);
    
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithOutNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            NSInteger random = arc4random() % kConstContent.length;
            random = MAX(10, random);
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoLayout;
            row.contentText = [kConstContent substringToIndex:random];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
}

- (void)testTextRowAutoLayoutWithNib
{
    DJTableViewRegister(self.aDJTableViewVM, DJTableViewVMTextTestRow, DJTableViewVMTextTestCell);
    
    [self.aDJTableViewVM removeAllSections];
    self.aDJTableViewVM.preCaculateHeightEnable = YES;
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            NSInteger random = arc4random() % kConstContent.length;
            random = MAX(10, random);
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoLayout;
            row.contentText = [kConstContent substringToIndex:random];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
}

- (void)testTextRowFrameLayout
{
    DJTableViewRegister(self.aDJTableViewVM, DJTableViewVMTextTestRow, DJTableViewVMTextFrameCell);
    
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 20; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"FrameLayout"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 100; i ++) {
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoFrameLayout;
            row.contentText = [NSString stringWithFormat:@"%d---%d,TextRowFrameLayout",i,j];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
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
            row.title = [NSString stringWithFormat:@"%d-Default-%d",j,i];
            __weak ViewController *weakSelf = self;
            [row setSelectionHandler:^(DJTableViewVMRow *rowVM) {
                [rowVM deselectRowAnimated:YES];
                [weakSelf testTable];
            }];
            [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
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
                DJLog(@"Move Complete");
            }];
            [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
}

- (void)testPrefetch
{
    [self.aDJTableViewVM removeAllSections];
    
    self.aDJTableViewVM.prefetchingEnabled = YES;
    
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
                DJLog(@"PrefetchHander->%d--%d",j,i);
            }];
            [row setPrefetchCancelHander:^(DJTableViewVMRow *rowVM) {
                DJLog(@"PrefetchCancelHander->%d--%d",j,i);
            }];
            [section addRow:row];
        }
    }
    [self.aDJTableViewVM reloadData];
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
            DJLog(@"delete->--%d",i);
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
            DJLog(@"delete->--%d",i);
        }];
        [row setDeleteCellCompleteHandler:^(DJTableViewVMRow *rowVM, void (^complete)()) {
            DJLog(@"delete %d with complete",i);
            DJAlertView *alertView = [[DJAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Are you want to delete rowVM \r\n with ID:%d?",i] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
            [alertView showWithCompletion:^(DJAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    complete();
                }
            }];
        }];
        [completeSection addRow:row];
    }
    [self.aDJTableViewVM reloadData];
}

- (void)testSlideActions
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
                DJLog(@"action 1");
            }];
            action1.backgroundColor = [UIColor orangeColor];
            
            UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"action 2" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                DJLog(@"action 2");
            }];
            action2.backgroundColor = [UIColor purpleColor];
            row.editActions = @[action1,action2];
        }
        
        [section addRow:row];
    }
}

- (void)testInsert
{
    DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"Insert"];
    [self.aDJTableViewVM addSection:section];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        if (i == 0) {
            row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        row.title = [NSString stringWithFormat:@"DeleteCell--%d",i];
        row.editingStyle = UITableViewCellEditingStyleInsert;
        [row setInsertCellHandler:^(DJTableViewVMRow *rowVM) {
            DJLog(@"tap insert");
        }];
        [section addRow:row];
    }
    [self.aDJTableViewVM reloadData];
}

- (void)testIndexTitle
{
    NSArray *sectionTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M",
                               @"N", @"O", @"P", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    [self.aDJTableViewVM removeAllSections];
    for (NSString *sectionTitle in sectionTitles) {
        DJTableViewVMSection *sectionVM = [DJTableViewVMSection sectionWithHeaderTitle:sectionTitle];
        sectionVM.sectionIndexTitle = sectionTitle;
        [self.aDJTableViewVM addSection:sectionVM];
        for (NSInteger i = 0 ; i < 6; i ++) {
            DJTableViewVMRow *row = [DJTableViewVMRow new];
            row.cellHeight = 70;
            row.title = [NSString stringWithFormat:@"Cell--%ld",(long)i];
            [sectionVM addRow:row];
        }
    }
    
    [self.aDJTableViewVM reloadData];
}

- (void)testLongTapActions
{
    DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"LongTapActions"];
    [self.aDJTableViewVM addSection:section];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        row.title = [NSString stringWithFormat:@"LongTapActions--%d",i];
        row.editingStyle = UITableViewCellEditingStyleInsert;
        [row setCopyHandler:^(DJTableViewVMRow *rowVM) {
            DJLog(@"tap copy with row:%zd",rowVM.indexPath.row);
        }];
        [row setCutHandler:^(DJTableViewVMRow *rowVM) {
            DJLog(@"tap cut with row:%zd",rowVM.indexPath.row);
        }];
        [row setPasteHandler:^(DJTableViewVMRow *rowVM) {
            DJLog(@"tap paste with row:%zd",rowVM.indexPath.row);
        }];
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
