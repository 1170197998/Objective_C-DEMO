//
//  MainViewController.m
//  仿头条新闻滑动效果
//
//  Created by Cocav on 16/3/20.
//  Copyright © 2016年 cocav. All rights reserved.
//
//   http://blog.csdn.net/feng2qing?viewmode=list

//get the width of the screen
#define SCR_W [UIScreen mainScreen].bounds.size.width

//get the width of the screen
#define SCR_H [UIScreen mainScreen].bounds.size.height

//custom RGB color
#define RGB(__r,__g,__b) [UIColor colorWithRed:(__r) / 255.0 green:(__g) / 255.0 blue:(__b) / 255.0 alpha:1]

#define topButtonWidth 100

#import "MainViewController.h"
#import "FirstTableViewController.h"
#import "SecondTableViewController.h"
#import "ThirdTableViewController.h"
#import "FourthTableViewController.h"
#import "FifthTableViewController.h"
#import "SixthTableViewController.h"
#import "SFPackageViewController.h"

@interface MainViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_topScrollView;
    UIScrollView *_mainScrollView;
    
    NSMutableArray *_mArrayTopButton;
    NSMutableArray *_mArrayTitle;
    NSMutableArray *_mArrayWithViewController;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    _mArrayTitle = [NSMutableArray array];
    _mArrayTopButton = [NSMutableArray array];
    
    [self setTopScrollView];
    [self setMainScrollView];
}

- (void)setTopScrollView
{
    _mArrayTitle = [NSMutableArray arrayWithObjects:@"推荐",@"娱乐",@"新闻",@"科技",@"体育",@"热点",nil];
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 20, SCR_W - 20, 40)];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = NO;
    _topScrollView.backgroundColor = [UIColor clearColor];
    
    for (NSInteger i = 0; i < _mArrayTitle.count; i ++) {
        UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(i * topButtonWidth, 0, topButtonWidth, 40)];
        [topButton setTitleColor:RGB(151, 194, 229) forState:UIControlStateNormal];
        [topButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [topButton setTitle:_mArrayTitle[i] forState:UIControlStateNormal];
        [_mArrayTopButton addObject:topButton];
        [_topScrollView addSubview:topButton
         ];
        topButton.tag = 6000 + i;
        [topButton addTarget:self action:@selector(clickTopButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    ((UIButton *)_mArrayTopButton[1]).selected = YES;
    [_topScrollView setContentSize:CGSizeMake(_mArrayTitle.count * topButtonWidth, 40)];
    ((UIButton *)_mArrayTopButton[1]).selected = YES;
    [_topScrollView setContentSize:CGSizeMake(_mArrayTitle.count * topButtonWidth, 40)];

    if(_topScrollView.contentSize.width - _topScrollView.frame.size.width <0)
    {
        [_topScrollView setContentOffset:CGPointMake(-(_topScrollView.frame.size.width - _topScrollView.contentSize.width)/2, 0) animated:NO];
    }
    [self.navigationController.view addSubview:_topScrollView];
}

- (void)clickTopButton:(UIButton *)sender
{
    // 设置Button的选中情况
    for (UIButton *button in _mArrayTopButton) {
        if (button.selected == YES) {
            button.selected = NO;
        }
    }
    sender.selected = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [_mainScrollView setContentOffset:CGPointMake((sender.tag - 6000) * SCR_W, 0)];
    }];
    
    //点击按钮的时候,topScrollView移动
    [SFPackageViewController setMoveScrollViewContentOffsetWithCurrentClickView:sender andMoveScrollView:_topScrollView];
    NSLog(@"_topScrollView.contentSize---%@",NSStringFromCGSize(_topScrollView.contentSize));
    NSLog(@"_topScrollView.contentOffset---%@",NSStringFromCGPoint(_topScrollView.contentOffset));
    NSLog(@"_topScrollView.frame---%@",NSStringFromCGRect(_topScrollView.frame));
    NSLog(@"_topScrollView.bounds---%@",NSStringFromCGRect(_topScrollView.bounds));
    NSLog(@"_topScrollView.contentInset---%@ \n \n",NSStringFromUIEdgeInsets(_topScrollView.contentInset));
}


- (void)setMainScrollView
{
    FirstTableViewController *firstVC = [[FirstTableViewController alloc] init];
    SecondTableViewController *secondVC = [[SecondTableViewController alloc] init];
    ThirdTableViewController *thirdVC = [[ThirdTableViewController alloc] init];
    FourthTableViewController *fourthVC = [[FourthTableViewController alloc] init];
    FifthTableViewController *fifthVC = [[FifthTableViewController alloc] init];
    SixthTableViewController *sixVC = [[SixthTableViewController alloc] init];
    _mArrayWithViewController = [NSMutableArray arrayWithObjects:firstVC,secondVC,thirdVC,fourthVC,fifthVC,sixVC, nil];
    
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCR_W, SCR_H)];
    [_mainScrollView setContentSize:CGSizeMake(SCR_W * _mArrayWithViewController.count, SCR_H)];
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    
    [_mainScrollView setContentOffset:CGPointMake(SCR_W, 0)];
    
    NSInteger i = 0;
    for (UIViewController *viewController in _mArrayWithViewController) {
        viewController.view.frame = CGRectMake(i * SCR_W, 0, SCR_W, _mainScrollView.frame.size.height);
        [_mainScrollView addSubview:viewController.view];
        i ++;
    }
    [self.view addSubview:_mainScrollView];
}

#pragma mark - UIscrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 设置Button的选中情况
    for (UIButton *button in _mArrayTopButton) {
        if (button.selected == YES) {
            button.selected = NO;
        }
    }
    ((UIButton *)[_mArrayTopButton objectAtIndex:scrollView.contentOffset.x / SCR_W]).selected = YES;
    
    //滑动主界面ScrollView的时候,topScrollView移动
    [SFPackageViewController setMoveScrollViewContentOffsetWithCurrentClickView:((UIButton *)[_mArrayTopButton objectAtIndex:scrollView.contentOffset.x / SCR_W]) andMoveScrollView:_topScrollView];
}

@end
