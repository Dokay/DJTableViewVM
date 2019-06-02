//
//  DJViewController.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJViewController.h"
#import "DJTableViewVM.h"
#import "DJTableViewVMTextAutoCell.h"
#import "DJTableViewVMTextTestCell.h"
#import "DJTableViewVMTextFrameCell.h"
#import "DJAlertView.h"
#import "DJInputCellTestController.h"
#import "DJLog.h"
#import "DJAdvanceViewController.h"

static const NSString *kConstContent = @"There are moments in life when you miss someone so much that you just want to pick them from your dreams and hug them for real! Dream what you want to dream;go where you want to go;be what you want to be,because you have only one life and one chance to do all the things you want to do.\n May you have enough happiness to make you sweet,enough trials to make you strong,enough sorrow to keep you human,enough hope to make you happy? Always put yourself in others’shoes.If you feel that it hurts you,it probably hurts the other person, too. \nThe happiest of people don’t necessarily have the best of everything;they just make the most of everything that comes along their way.Happiness lies for those who cry,those who hurt, those who have searched,and those who have tried,for only they can appreciate the importance of people. \n who have touched their lives.Love begins with a smile,grows with a kiss and ends with a tear.The brightest future will always be based on a forgotten past, you can’t go on well in lifeuntil you let go of your past failures and heartaches.\n When you were born,you were crying and everyone around you was smiling.Live your life so that when you die,you're the one who is smiling and everyone around you is crying.\n Please send this message to those people who mean something to you,to those who have touched your life in one way or another,to those who make you smile when you really need it,to those that make you see the brighter side of things when you are really down,to those who you want to let them know that you appreciate their friendship.And if you don’t, don’t worry,nothing bad will happen to you,you will just miss out on the opportunity to brighten someone’s day with this message.";

@interface DJViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *aDJTableViewVM;

@end

@implementation DJViewController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    DJ_LOG_ENABLE = YES;
    
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
            [self testTextRowAutoLayoutWithoutNib];
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
            [self testEdit];
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
        case 14:
        {
            [self testRevealView];
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
                                @{@"title":@"AutoLayoutWithoutNibDemo",
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
                                @{@"title":@"EditDemo",
                                  @"jumpID":@(9)},
                                @{@"title":@"IndexTitle",
                                  @"jumpID":@(10)},
                                @{@"title":@"LongTapActions",
                                  @"jumpID":@(11)},
                                @{@"title":@"TextInputDemo",
                                  @"jumpID":@(12)},
                                @{@"title":@"AdvanceCellDemo",
                                  @"jumpID":@(13)},
                                @{@"title":@"VMRevealView",
                                  @"jumpID":@(14)},];
    
    __weak DJViewController *weakSelf = self;
    
    [self.aDJTableViewVM removeAllSections];
    DJTableViewVMSection *contenteSection = [DJTableViewVMSection sectionWithHeaderHeight:0];
    [self.aDJTableViewVM addSection:contenteSection];
    for (NSDictionary *testDic in testDataSource) {
        DJTableViewVMRow *testRowVM = [DJTableViewVMRow new];
        testRowVM.paramObject = testDic;
        testRowVM.title = [testDic valueForKey:@"title"];
        testRowVM.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [testRowVM setSelectionHandler:^(DJTableViewVMRow *rowVM) {
            [rowVM deselectRowAnimated:YES];
            if ([rowVM.title isEqualToString:@"TextInputDemo"]) {
                DJInputCellTestController *aDJInputCellTestController = [DJInputCellTestController new];
                [weakSelf.navigationController pushViewController:aDJInputCellTestController animated:YES];
            }else if([rowVM.title isEqualToString:@"AdvanceCellDemo"]) {
                DJAdvanceViewController *aDJAdvanceViewController = [DJAdvanceViewController new];
                [weakSelf.navigationController pushViewController:aDJAdvanceViewController animated:YES];
            }else{
                DJViewController *aViewController = [DJViewController new];
                aViewController.type = [[testDic objectForKey:@"jumpID"] integerValue];
                [weakSelf.navigationController pushViewController:aViewController animated:YES];
            }
        }];
        [contenteSection addRow:testRowVM];
    }
    
    [self.aDJTableViewVM reloadData];
}

- (void)testTextRowAutoLayoutWithoutNib
{
    DJTableViewRegister(self.aDJTableViewVM, DJTableViewVMTextTestRow, DJTableViewVMTextAutoCell);
    
    [self.aDJTableViewVM removeAllSections];
    
    for (int j = 0; j < 10; j++) {
        NSAttributedString *headerAttributedString = [[NSAttributedString alloc] initWithString:@"AutoLayoutWithoutNib" attributes:@{NSForegroundColorAttributeName:[UIColor purpleColor]}];
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderAttributedText:headerAttributedString edgeInsets:UIEdgeInsetsMake(10, 15, 10, 15)];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 40; i ++) {
            NSInteger random = (j+1) * 10 + 5 * i;
            random = MAX(10, random);
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoLayout;
            row.contentText = [kConstContent substringToIndex:random];
            __weak DJViewController *weakSelf = self;
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
    
    for (int j = 0; j < 10; j++) {
        DJTableViewVMSection *section = [DJTableViewVMSection sectionWithHeaderTitle:@"AutoLayoutWithNib"];
        [self.aDJTableViewVM addSection:section];
        for (int i  = 0; i < 40; i ++) {
            NSInteger random = (j+1) * 10 + 5 * i;
            random = MAX(10, random);
            DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
            row.heightCaculateType = DJCellHeightCaculateAutoLayout;
            row.contentText = [kConstContent substringToIndex:random];
            __weak DJViewController *weakSelf = self;
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
            __weak DJViewController *weakSelf = self;
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
            __weak DJViewController *weakSelf = self;
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
            __weak DJViewController *weakSelf = self;
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

- (void)testEdit
{
    DJTableViewVMSection *insertSection = [DJTableViewVMSection sectionWithHeaderTitle:@"Insert"];
    [self.aDJTableViewVM addSection:insertSection];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        if (i == 0) {
            row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        row.title = [NSString stringWithFormat:@"InsertCell--%d",i];
        row.editingStyle = UITableViewCellEditingStyleInsert;
        __weak typeof(insertSection) weakSection = insertSection;
        [row setInsertCellHandler:^(DJTableViewVMRow *rowVM) {
            DJLog(@"tap insert");
            __strong typeof(insertSection) strongSection = weakSection;
            
            DJTableViewVMRow *insertRow = [DJTableViewVMRow new];
            insertRow.title = [NSString stringWithFormat:@"new cell with index:%@",@(0)];
            
            [strongSection insertRow:insertRow atIndex:0 withRowAnimation:UITableViewRowAnimationLeft];
        }];
        
        [insertSection addRow:row];
    }
    
    DJTableViewVMSection *deleteSection = [DJTableViewVMSection sectionWithHeaderTitle:@"Delete"];
    [self.aDJTableViewVM addSection:deleteSection];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        if (i == 0) {
            row.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        }
        row.title = [NSString stringWithFormat:@"DeleteCell--%d",i];
        row.editingStyle = UITableViewCellEditingStyleDelete;
        [row setDeleteCellHandler:^(id  _Nonnull rowVM) {
            
        }];
        [deleteSection addRow:row];
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
 
    
    [self.aDJTableViewVM reloadData];
}

- (void)testRevealView
{
    DJTableViewRegister(self.aDJTableViewVM, DJTableViewVMTextTestRow, DJTableViewVMTextTestCell);
    
    self.title = @"reveal view";
    
    self.aDJTableViewVM.tableHeaderView = [self headerView:@"this is a table header"];
    self.aDJTableViewVM.tableFooterView = [self headerView:@"this is a table footer"];
    
    DJTableViewVMSection *titlesection = [DJTableViewVMSection sectionWithHeaderTitle:@"tap cell three times quickly to open reveal vc"];
    [self.aDJTableViewVM addSection:titlesection];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMRow *row = [DJTableViewVMRow new];
        row.cellHeight = 70;
        row.selectionStyle = UITableViewCellSelectionStyleNone;
        row.title = [NSString stringWithFormat:@"row--%d",i];
        [titlesection addRow:row];
    }
    
    
    DJTableViewVMSection *customViewSection = [DJTableViewVMSection sectionWithHeaderView:[self headerView:@"this is a section header"]];
    [self.aDJTableViewVM addSection:customViewSection];
    for (int i  = 0; i < 5; i ++) {
        DJTableViewVMTextTestRow *row = [DJTableViewVMTextTestRow new];
        row.heightCaculateType = DJCellHeightCaculateAutoLayout;
        row.selectionStyle = UITableViewCellSelectionStyleNone;
        row.contentText = [NSString stringWithFormat:@"%d---,TextRowFrameLayout",i];
        [customViewSection addRow:row];
    }
    
    [self.aDJTableViewVM reloadData];
}

- (UIView *)headerView:(NSString *)header{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
    label.text = header;
    label.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:label];
    return headerView;
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
