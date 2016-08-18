//
//  InputToolbar.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "InputToolbar.h"
#import "MoreButtonView.h"
#import "LeftButtonView.h"
#import "EmojiButtonView.h"

@interface InputToolbar ()<UITextViewDelegate>
@property (nonatomic,strong)LeftButtonView *leftButtonView;
@property (nonatomic,strong)EmojiButtonView *emojiButtonView;
@property (nonatomic,strong)MoreButtonView *moreButtonView;
@end

@implementation InputToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
        [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 49 + 200)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        [self layoutUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWasShow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    CGSize size = [[dictionary objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - size.height - 49, SCREEN_HEIGHT, 200)];
    NSLog(@"%@",NSStringFromCGSize(size));
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 49, SCREEN_WIDTH, 200)];
}

- (void)layoutUI
{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 30, 30)];
    [self.leftButton setImage:[UIImage imageNamed:@"liaotian_ic_yuyin_nor"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"liaotian_ic_press"] forState:UIControlStateHighlighted];
    [self.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    self.textInput = [[UITextView alloc] initWithFrame:CGRectMake(50, 9, SCREEN_WIDTH - 150, 30)];
    self.inputView.backgroundColor = [UIColor purpleColor];
    self.textInput.layer.cornerRadius = 3;
    self.textInput.layer.masksToBounds = YES;
    self.textInput.returnKeyType = UIReturnKeySend;
    self.textInput.delegate = self;
    [self addSubview:self.textInput];
    
    self.emojiButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textInput.frame) + 10, 9, 30, 30)];
    [self.emojiButton setImage:[UIImage imageNamed:@"liaotian_ic_jianpan_nor"] forState:UIControlStateNormal];
    [self.emojiButton setImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_press"] forState:UIControlStateHighlighted];
    [self.emojiButton addTarget:self action:@selector(clickEmojiButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emojiButton];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.emojiButton.frame) + 10, 9, 30, 30)];
    [self.moreButton setImage:[UIImage imageNamed:@"liaotian_ic_gengduo_press"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"liaotian_ic_gengduo_press"] forState:UIControlStateHighlighted];
    [self.moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];

    self.leftButtonView = [[LeftButtonView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 200)];
    [self addSubview:self.leftButtonView];
    
    self.emojiButtonView = [[EmojiButtonView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 200)];
    [self addSubview:self.emojiButtonView];
    
    self.moreButtonView = [[MoreButtonView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 200)];
    [self addSubview:self.moreButtonView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"发送文字为:%@",textView.text);
        textView.text = nil;
        return NO;
    }
    return YES;
}

- (void)clickLeftButton
{
    if (CGRectGetMaxY(self.frame) == SCREEN_HEIGHT + 200 || self.leftButtonView.hidden == YES) {
        [UIView animateWithDuration:0.35 animations:^{
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 200 - 49, SCREEN_WIDTH, 49 + 200)];
            [self.textInput resignFirstResponder];
            self.leftButtonView.hidden = NO;
            self.emojiButtonView.hidden = YES;
            self.moreButtonView.hidden = YES;
        }];
    } else {
        [self.textInput becomeFirstResponder];
        [self.leftButtonView setHidden:YES];
    }
}

- (void)clickEmojiButton
{
    if (CGRectGetMaxY(self.frame) == SCREEN_HEIGHT + 200 || self.emojiButtonView.hidden == YES) {
        [UIView animateWithDuration:0.35 animations:^{
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 200 - 49, SCREEN_WIDTH, 49 + 200)];
            [self.textInput resignFirstResponder];
            self.leftButtonView.hidden = YES;
            self.emojiButtonView.hidden = NO;
            self.moreButtonView.hidden = YES;
        }];
    } else {
        [self.textInput becomeFirstResponder];
        [self.emojiButtonView setHidden:YES];
    }
}

- (void)clickMoreButton
{
    if (CGRectGetMaxY(self.frame) == SCREEN_HEIGHT + 200 || self.moreButtonView.hidden == YES) {
        [UIView animateWithDuration:0.35 animations:^{
            [self setFrame:CGRectMake(0, SCREEN_HEIGHT - 200 - 49, SCREEN_WIDTH, 49 + 200)];
            [self.textInput resignFirstResponder];
            self.leftButtonView.hidden = YES;
            self.emojiButtonView.hidden = YES;
            self.moreButtonView.hidden = NO;
        }];
    } else {
        [self.moreButtonView setHidden:YES];
        [self.textInput becomeFirstResponder];
    }
}

@end
