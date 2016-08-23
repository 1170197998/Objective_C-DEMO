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

@property (nonatomic,assign)BOOL isBecomeFirstResponder;
@property (nonatomic,assign)NSInteger textViewMaxVisibleLine;
/**
 *  点击发送后要发送的文本
 */
@property (nonatomic,strong)void(^sendContent)(NSString *content);

- (void)setMorebuttonViewDelegate:(id)delegate;



@end
