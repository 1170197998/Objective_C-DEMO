//
//  InputToolbar.h
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreButtonView.h"
#import "LeftButtonView.h"
#import "EmojiButtonView.h"
#import "UIView+Extension.h"

@interface InputToolbar : UIView

/**
 *  设置第一响应
 */
@property (nonatomic,assign)BOOL isBecomeFirstResponder;

/**
 *  设置输入框最多可见行数
 */
@property (nonatomic,assign)NSInteger textViewMaxVisibleLine;

/**
 *  点击发送后要发送的文本
 */
@property (nonatomic,strong)void(^sendContent)(NSString *content);

/**
 *  添加moreButtonView代理
 */
- (void)setMorebuttonViewDelegate:(id)delegate;



@end
