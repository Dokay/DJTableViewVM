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

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DJTableViewVM *aDJTableViewVM;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self testTextRowFrameLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            row.contentText = @"gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985";
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
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
            row.contentText = @"gshegsehgseghhsiughesiugh49egh94egh4e9gh9urghrdughdugh98t4h98hte498hte489the498the5985";
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
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
            row.contentText = [NSString stringWithFormat:@"%d--%d gshghseghsughsugseuigseugseugseugseuigseghseeihsgeihgisehogishegoieshgosei",j,i];
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
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
            [row setSelectionHandler:^(DJTableViewVMRow *roff) {
                [roff deselectRowAnimated:YES];
            }];
            [section addRow:row];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - getter
- (DJTableViewVM *)aDJTableViewVM
{
    if (_aDJTableViewVM== nil) {
        _aDJTableViewVM= [[DJTableViewVM alloc] initWithTableView:self.tableView];
    }
    return _aDJTableViewVM;
}

@end
