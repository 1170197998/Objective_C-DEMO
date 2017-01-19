//
//  FifthTableViewController.m
//  仿头条新闻滑动效果
//
//  Created by Cocav on 16/3/20.
//  Copyright © 2016年 cocav. All rights reserved.
//

#import "FifthTableViewController.h"

@interface FifthTableViewController ()

@end

@implementation FifthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.text = @"第5个控制器的视图";
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
    [self.view addSubview:label];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
