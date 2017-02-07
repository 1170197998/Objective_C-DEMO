//
//  JumpViewController.m
//  StarEvaluateAndShow
//
//  Created by ShaoFeng on 16/3/23.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "JumpViewController.h"
#import "StartEvaluateAndShow.h"

@interface JumpViewController ()
@property (nonatomic,strong) StarView *starView;

@end

@implementation JumpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    self.starView = [[StarView alloc] initWithFrame:CGRectMake(100, 100, 240, 40)];
    self.starView.backgroundColor = [UIColor clearColor];
    NSLog(@"%f",self.starNum);
    [self.starView setStar:self.starNum / 2];

    [self.navigationController.view addSubview:self.starView];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
