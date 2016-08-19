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
@interface InputToolbar : UIView
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UITextView *textInput;
@property (nonatomic,strong)UIButton *emojiButton;
@property (nonatomic,strong)UIButton *moreButton;

@property (nonatomic,strong)LeftButtonView *leftButtonView;
@property (nonatomic,strong)EmojiButtonView *emojiButtonView;
@property (nonatomic,strong)MoreButtonView *moreButtonView;
@end
