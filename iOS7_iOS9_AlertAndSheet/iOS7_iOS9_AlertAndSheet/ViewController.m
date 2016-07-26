//
//  ViewController.m
//  iOS7_iOS9_AlertAndSheet
//
//  Created by ShaoFeng on 16/4/8.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] <= 8.0)

#import "ViewController.h"
#import "AlertViewController_block.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat buttonW = 100;
    UIButton *alertViewButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 2 * buttonW) / 3, 100, buttonW, 40)];
    alertViewButton.backgroundColor = [UIColor greenColor];
    [alertViewButton addTarget:self action:@selector(clickAlertViewButton) forControlEvents:UIControlEventTouchUpInside];
    [alertViewButton setTitle:@"AlertView" forState:UIControlStateNormal];
    [self.view addSubview:alertViewButton];
    
    UIButton *actionSheetButton = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 2 * buttonW) / 1.5 + buttonW, 100, buttonW, 40)];
    actionSheetButton.backgroundColor = [UIColor greenColor];
    [actionSheetButton addTarget:self action:@selector(clickActionSheetButton) forControlEvents:UIControlEventTouchUpInside];
    [actionSheetButton setTitle:@"ActionSheet" forState:UIControlStateNormal];
    [self.view addSubview:actionSheetButton];
}

- (void)clickAlertViewButton
{
    if (iOS7) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"确定删除吗" leftButtonItem:[SFButtonItem itemButtonTitle:@"取消" action:^{
            
            NSLog(@"点击了取消");
        }] rightButtonItems:[SFButtonItem itemButtonTitle:@"确定" action:^{
            
            NSLog(@"点击了确定");
        }], nil] show];
        
    } else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确定删除吗" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击了取消");
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"点击了确定");
        }];
        [alertController addAction:deleteAction];
        [alertController addAction:cancelAction];
    }
}

- (void)clickActionSheetButton
{
    if  (iOS7){
        [[[UIActionSheet alloc] initWithTitle:@"提示" cancelButtonItem:[SFButtonItem itemButtonTitle:@"取消" action:^{
            
        }] destructiveButtonItem:[SFButtonItem itemButtonTitle:@"条目1" action:^{
            
        }] otherButtonItems:[SFButtonItem itemButtonTitle:@"条目2" action:^{
            
        }], [SFButtonItem itemButtonTitle:@"条目3" action:^{
            
        }],nil] showInView:self.view];
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *alert1 = [UIAlertAction actionWithTitle:@"条目1" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alert2 = [UIAlertAction actionWithTitle:@"条目2" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *alert3 = [UIAlertAction actionWithTitle:@"条目3" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:alert1];
        [alertController addAction:alert2];
        [alertController addAction:alert3];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
