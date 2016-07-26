//
//  ViewController.m
//  SFTextField
//
//  Created by ShaoFeng on 16/6/16.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"
#import "SFTextField.h"
@interface ViewController ()
@property (nonatomic,strong)SFTextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField = [[SFTextField alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.cornerRadius = 3.0;
    self.textField.layer.masksToBounds = YES;
    [self.view addSubview:self.textField];
    
    UISwitch *swich = [[UISwitch alloc] initWithFrame:CGRectMake(10, 100, 10, 10)];
    [swich addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:swich];
}

- (void)clickSwitch:(UISwitch *)sender
{
    self.textField.secureTextEntry = sender.on;
}

@end
