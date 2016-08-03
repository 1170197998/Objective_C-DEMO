//
//  ViewController.m
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"
#import "CellModel.h"
#import "SectionModel.h"
#import "HeaderView.h"
#import "TableViewCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

/**
 *  初始化数据源
 */
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 20; i ++) {
            
            SectionModel *sectionModel = [[SectionModel alloc] init];
            sectionModel.isExpanded = NO;
            sectionModel.sectionTitle = [NSString stringWithFormat:@"第%ld组",(long)i + 1];
            NSMutableArray *cellModels = [NSMutableArray array];
            
            for (NSInteger j = 0; j < 10; j ++) {
                CellModel *cellModel = [[CellModel alloc] init];
                cellModel.cellTitle = [NSString stringWithFormat:@"第%ld组,第%ld行",i + 1,j + 1];
                [cellModels addObject:cellModel];
            }
            sectionModel.cellModels = cellModels;
            [self.dataSource addObject:sectionModel];
        }
    }
    return _dataSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionModel *sectionModel = [self dataSource][section];
    return sectionModel.isExpanded ? sectionModel.cellModels.count : 0;
}

/**
 *  返回单个cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"id";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.cellModel = [[self dataSource][indexPath.section] cellModels][indexPath.row];
    return cell;
}

/**
 *  返回headerView
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *idenfifer = @"id";
    HeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:idenfifer];
    if (header == nil) {
        header = [[HeaderView alloc] initWithReuseIdentifier:idenfifer];
    }
    header.sectionModel = [self dataSource][section];
    header.expandCallBack = ^(BOOL isExpanded) {
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

@end
