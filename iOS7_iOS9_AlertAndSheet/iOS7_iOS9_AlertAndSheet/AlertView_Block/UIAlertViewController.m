//
//  UIAlertViewController.m
//  iOS7_iOS9_AlertAndSheet
//
//  Created by ShaoFeng on 2016/12/5.
//  Copyright © 2016年 Cocav. All rights reserved.
//
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] <= 8.0)

#import "UIAlertViewController.h"
#import "AlertViewController_block.h"
#import "UIAlertController+Blocks.h"
@implementation UIAlertViewController
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)lelftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle
{
    if (self = [self initWithTitle:title message:message leftButtonTitle:lelftButtonTitle rightButtonTitle:rightButtonTitle]) {
        if (iOS7) {
            
            [[[UIAlertView alloc] initWithTitle:nil message:message leftButtonItem:[SFButtonItem itemButtonTitle:lelftButtonTitle action:^{
                NSLog(@"点击了取消");
            }] rightButtonItems:[SFButtonItem itemButtonTitle:rightButtonTitle action:^{
                NSLog(@"点击了确定");
            }], nil] show];
            
        } else {
           [[UIAlertController alloc] initWithTitle:title message:message leftButtonItem:[SFButtonItem itemButtonTitle:lelftButtonTitle action:^{
                
            }] rightButtonItem:[SFButtonItem itemButtonTitle:rightButtonTitle action:^{
                
            }]];
        }
    }
    return self;
}
@end
