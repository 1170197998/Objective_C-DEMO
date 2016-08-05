//
//  ViewController.m
//  MultiLanguage
//
//  Created by ShaoFeng on 16/8/4.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *test1;
@property (strong, nonatomic) IBOutlet UIButton *test2;
@property (strong, nonatomic) IBOutlet UIButton *operatorButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.test1 setTitle:NSLocalizedString(@"huawei", nil) forState:UIControlStateNormal];
    [self.test2 setTitle:NSLocalizedString(@"apple", nil) forState:UIControlStateNormal];
}

@end
