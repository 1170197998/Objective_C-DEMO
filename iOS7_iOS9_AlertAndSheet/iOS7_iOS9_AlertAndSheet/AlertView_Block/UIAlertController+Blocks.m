//
//  UIAlertController+Blocks.m
//  iOS7_iOS9_AlertAndSheet
//
//  Created by ShaoFeng on 2016/12/5.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "UIAlertController+Blocks.h"

@implementation UIAlertController (Blocks)
- (void)initWithTitle:(NSString *)title message:(NSString *)message leftButtonItem:(SFButtonItem *)leftButtonItem rightButtonItem:(SFButtonItem *)rightButtonItem
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
}
@end
