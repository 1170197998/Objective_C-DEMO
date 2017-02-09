//
//  ViewController.m
//  TouchID
//
//  Created by ShaoFeng on 2017/2/9.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self testTouchID];
}

- (void)testTouchID
{
    LAContext *context = [[LAContext alloc] init];
    context.localizedCancelTitle = @"取消";
    context.localizedFallbackTitle = @"输入密码";

    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        NSLog(@"支持使用");
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过指纹验证解锁" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                NSLog(@"验证成功");
            } else {
        
                /*
                 #define kLAErrorAuthenticationFailed                       -1  授权失败
                 #define kLAErrorUserCancel                                 -2  取消授权
                 #define kLAErrorUserFallback                               -3  用户选择了另一种方式,输入密码方式验证
                 #define kLAErrorSystemCancel                               -4  系统取消授权(例如其他APP切入)
                 #define kLAErrorPasscodeNotSet                             -5  系统未设置密码
                 #define kLAErrorTouchIDNotAvailable                        -6  指纹不正确
                 #define kLAErrorTouchIDNotEnrolled                         -7  设备Touch ID不可用，例如未打开
                 #define kLAErrorTouchIDLockout                             -8  TouchID被锁定
                 #define kLAErrorAppCancel                                  -9  App取消验证
                 #define kLAErrorInvalidContext                                 无效的上下文环境
                 */
                
                if (error.code == kLAErrorAuthenticationFailed) {
                    NSLog(@"授权失败,三次输入错误");
                } else if (error.code == kLAErrorUserCancel) {
                    NSLog(@"用户取消");
                } else if (error.code == kLAErrorUserFallback) {
                    NSLog(@"用户选择了另一种方式,输入密码方式验证");
                } else if (error.code == kLAErrorTouchIDNotAvailable) {
                    NSLog(@"指纹不正确");
                } else if (error.code == kLAErrorTouchIDLockout) {
                    NSLog(@"TouchID被锁定,重新锁屏再开启即可");
                }
            }
        }];
    } else {
        NSLog(@"不支持使用--%@",error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
