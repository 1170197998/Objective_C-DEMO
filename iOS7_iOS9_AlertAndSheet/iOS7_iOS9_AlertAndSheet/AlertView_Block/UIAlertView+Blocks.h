//
//  UIAlertView+Blocks.h
//  MeetYou
//
//  Created by Cocav on 16/2/19.
//  Copyright © 2016年 Eason. All rights reserved.


#import <UIKit/UIKit.h>
#import "SFButtonItem.h"

@interface UIAlertView (Blocks)

/**
 *  <#Description#>
 *
 *  @param inTitle            标题
 *  @param inMessage          提示内容
 *  @param inLeftButtonItem   左按钮
 *  @param inRightButtonItems 右按钮
 *
 *  @return id
 */
-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage leftButtonItem:(SFButtonItem *)inLeftButtonItem rightButtonItems:(SFButtonItem *)inRightButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(SFButtonItem *)item;

@end
