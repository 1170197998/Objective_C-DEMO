//
//  UIActionSheet+Blocks.h
//  MeetYou
//
//  Created by Cocav on 16/2/19.
//  Copyright © 2016年 Eason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFButtonItem.h"

@interface UIActionSheet (Blocks) <UIActionSheetDelegate>

/**
 *  用来初始化UIActionSheet
 *
 *  @param inTitle            提示标题
 *  @param inCancelButtonItem 取消按钮(最下)
 *  @param inDestructiveItem  中间按钮
 *  @param inOtherButtonItems 上面按钮
 *
 *  @return id
 */
-(id)initWithTitle:(NSString *)inTitle cancelButtonItem:(SFButtonItem *)inCancelButtonItem destructiveButtonItem:(SFButtonItem *)inDestructiveItem otherButtonItems:(SFButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  添加其他按钮
 */
- (NSInteger)addButtonItem:(SFButtonItem *)item;

/** 
 *    action sheet is dismssed for any reason.
 */
@property (copy, nonatomic) void(^dismissalAction)();
@end
