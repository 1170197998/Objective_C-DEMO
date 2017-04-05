//
//  ViewController.m
//  AssistiveTouchDemo
//
//  Created by ShaoFeng on 2016/11/8.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(strong,nonatomic)UIWindow *window;
@property(strong,nonatomic)UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.window addSubview:self.button];
    [self.window makeKeyAndVisible];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.window resignKeyWindow];
    self.window = nil;
}

- (UIWindow *)window
{
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.height - 80 - 50, 60, 60)];
        _window.windowLevel = UIWindowLevelAlert + 1;
    }
    return _window;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, 60, 60);
        [_button addTarget:self action:@selector(sendCircle) forControlEvents:UIControlEventTouchUpInside];
        _button.backgroundColor = [UIColor greenColor];
        _button.layer.cornerRadius = 30;
        _button.layer.masksToBounds = YES;
    }
    return _button;
}

- (void)sendCircle
{
    NSLog(@"当前界面有效");
}

@end
