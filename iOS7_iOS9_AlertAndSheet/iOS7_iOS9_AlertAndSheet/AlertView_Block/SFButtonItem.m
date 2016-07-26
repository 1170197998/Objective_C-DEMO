//
//  SFButtonIndex.h
//  MeetYou
//
//  Created by Cocav on 16/2/19.
//  Copyright © 2016年 Eason. All rights reserved.

#import "SFButtonItem.h"

@implementation SFButtonItem
@synthesize label;
@synthesize action;

+(id)item
{
    return [self new];
}

#pragma makr - 有标题,没有点击事件
+(id)itemButtonTitle:(NSString *)inButtonTitle;
{
    SFButtonItem *newItem = [self item];
    [newItem setLabel:inButtonTitle];
    return newItem;
}

#pragma mark - 有标题,有点击事件
+(id)itemButtonTitle:(NSString *)inButtonTitle action:(void(^)(void))action;
{
  SFButtonItem *newItem = [self itemButtonTitle:inButtonTitle];
  [newItem setAction:action];
  return newItem;
}

@end

