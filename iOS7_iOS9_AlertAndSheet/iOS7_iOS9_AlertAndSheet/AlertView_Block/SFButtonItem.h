//
//  SFButtonIndex.h
//  MeetYou
//
//  Created by Cocav on 16/2/19.
//  Copyright © 2016年 Eason. All rights reserved.

#import <Foundation/Foundation.h>

@interface SFButtonItem : NSObject
{
    NSString *label;
    void (^action)();
}
@property (retain, nonatomic) NSString *label;
@property (copy, nonatomic) void (^action)();

+(id)item;

/**
 *  只有标题,无点击事件
 */
+(id)itemButtonTitle:(NSString *)inButtonTitle;

/**
 *  有标题,有点击事件
 */
+(id)itemButtonTitle:(NSString *)inButtonTitle action:(void(^)(void))action;
@end

