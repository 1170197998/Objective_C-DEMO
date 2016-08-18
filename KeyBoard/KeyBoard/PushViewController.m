//
//  PushViewController.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "PushViewController.h"
#import "InputToolbar.h"
@interface PushViewController ()
@property (nonatomic,strong)InputToolbar *inputToolbar;
@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.inputToolbar = [[InputToolbar alloc] init];
    [self.view addSubview:self.inputToolbar];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.inputToolbar.textInput resignFirstResponder];
}

@end
