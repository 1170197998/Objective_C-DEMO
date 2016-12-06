//
//  UIAlertViewController.h
//  iOS7_iOS9_AlertAndSheet
//
//  Created by ShaoFeng on 2016/12/5.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertViewController : NSObject

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message leftButtonTitle:(NSString *)lelftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle;

@end
