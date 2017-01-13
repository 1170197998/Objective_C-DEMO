//
//  ViewController.m
//  SearchHelight
//
//  Created by ShaoFeng on 2017/1/13.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"

static NSString *const CellIdentifier = @"CellIdentifier";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *dataResult;
@property (nonatomic, retain)UISearchController *searchController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray arrayWithObjects:@"北京海淀",@"上海虹桥",@"798艺术区",@"广州深圳",@"shanghai",@"内蒙古大草原",@"河北石家庄",@"湖南长沙",@"海南三亚",@"湖北武汉",@"陕西西安火车站", nil];
    [self setTableView];
    [self setSearchBar];
}

- (void)setTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)setSearchBar
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchBar.frame = CGRectMake(0, 44, 0, 44);
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.showsCancelButton = YES;
    //显示搜索结果的VC
    self.searchController.searchResultsUpdater = self;
    //搜索结果显示
    self.searchController.active = YES;
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        
        return self.dataResult.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    // 显示搜索结果时
    if (self.searchController.active) {
        // 原始搜索结果字符串.
        NSString *originResult = self.dataResult[indexPath.row];
        // 获取关键字的位置
        NSRange range = [originResult rangeOfString:self.searchController.searchBar.text];
        // 转换成可以操作的字符串类型.
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:originResult];
        // 添加属性(粗体)
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
        // 关键字高亮
        [attribute addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        // 将带属性的字符串添加到cell.textLabel上.
        [cell.textLabel setAttributedText:attribute];
        cell.textLabel.text = self.dataResult[indexPath.row];
        
    } else {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) {
        NSLog(@"点击了%@",self.dataResult[indexPath.row]);
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //初始化存储搜索结果的数组
    self.dataResult = [NSMutableArray array];
    // 获取关键字
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchController.searchBar.text];
    // 用关键字过滤数组中的内容, 将过滤后的内容放入结果数组
    self.dataResult = [[self.dataSource filteredArrayUsingPredicate:predicate] mutableCopy];
    // 完成数据的过滤和存储后刷新tableView.
    [self.tableView reloadData];
}

@end
