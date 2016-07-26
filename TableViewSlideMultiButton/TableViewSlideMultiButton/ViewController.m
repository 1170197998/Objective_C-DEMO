//
//  ViewController.m
//  TableViewSlideMultiButton
//
//  Created by ShaoFeng on 16/7/26.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource =[[NSMutableArray alloc] initWithObjects:@"联想",@"华为",@"苹果",@"三星",@"小米",@"锤子",@"OPPO",@"诺基亚",@"一加",@"格力",nil];

    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"id"];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.item];
    return  cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 1. 更新数据
        [_dataSource removeObjectAtIndex:indexPath.row];
        // 2. 更新UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除按钮
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除按钮");
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    //更多按钮
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了更多按钮");
        [self.tableView reloadData];
    }];
    moreAction.backgroundColor = [UIColor orangeColor];
    
    //置顶按钮
    UITableViewRowAction *topAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了置顶按钮");
        [self.dataSource insertObject:self.dataSource[indexPath.row] atIndex:0];
        [self.dataSource removeObjectAtIndex:indexPath.row + 1];
        [self.tableView reloadData];
    }];
    
    return @[deleteAction,moreAction,topAction];
}

@end
