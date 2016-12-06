//
//  UIAlertController+Blocks.h
//  iOS7_iOS9_AlertAndSheet
//
//  Created by ShaoFeng on 2016/12/5.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFButtonItem.h"

@interface UIAlertController (Blocks)
- (void)initWithTitle:(NSString *)title message:(NSString *)message leftButtonItem:(SFButtonItem *)leftButtonItem rightButtonItem:(SFButtonItem *)rightButtonItem;
@end
