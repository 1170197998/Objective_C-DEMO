//
//  ViewController.m
//  StarEvaluateAndShow
//
//  Created by ShaoFeng on 16/3/23.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"
#import "StartEvaluateAndShow.h"
#import "JumpViewController.h"
@interface ViewController ()<RatingBarDelegate>
{
    CGFloat _starNum;
}
@property (nonatomic,strong)UILabel *showLabel;
@property (nonatomic,strong)RatingBar *ratingBar;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UIButton *buttonJump;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    [self.buttonJump addTarget:self action:@selector(clickJumpButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickJumpButton
{
    JumpViewController *vc= [[JumpViewController alloc] init];
    vc.starNum = _starNum;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.ratingBar = [[RatingBar alloc] initWithFrame:CGRectMake(130, [UIScreen mainScreen].bounds.size.height / 2, 50, 20)];
    [self.ratingBar setImageDeselected:@"iconfont-xingunselected" halfSelected:@"iconfont-banxing" fullSelected:@"iconfont-xing" andDelegate:self];
    [self.view addSubview:self.ratingBar];
}

- (void)ratingBar:(RatingBar *)ratingBar ratingChanged:(float)newRating
{
    _starNum = newRating;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
