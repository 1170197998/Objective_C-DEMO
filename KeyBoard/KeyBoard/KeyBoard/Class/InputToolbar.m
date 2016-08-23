//
//  InputToolbar.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define customKeyboardHeight 200
#define InputToolbarHeight 49

#import "InputToolbar.h"

@interface InputToolbar ()<UITextViewDelegate,EmojiButtonViewDelegate>
@property (nonatomic, assign)CGFloat textInputHeight;
@property (nonatomic, assign)NSInteger TextInputMaxHeight;
@property (nonatomic, assign)NSInteger keyboardHeight;
@property (nonatomic, assign) BOOL showKeyboardButton;

@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UITextView *textInput;
@property (nonatomic,strong)UIButton *emojiButton;
@property (nonatomic,strong)UIButton *moreButton;

@property (nonatomic,strong)LeftButtonView *leftButtonView;
@property (nonatomic,strong)EmojiButtonView *emojiButtonView;
@property (nonatomic,strong)MoreButtonView *moreButtonView;

@end

@implementation InputToolbar

- (LeftButtonView *)leftButtonView
{
    if (!_leftButtonView) {
        self.leftButtonView = [[LeftButtonView alloc] init];
        self.leftButtonView.width = self.width;
        self.leftButtonView.height = customKeyboardHeight;
        _keyboardHeight = customKeyboardHeight;
    }
    return _leftButtonView;
}

- (EmojiButtonView *)emojiButtonView
{
    if (!_emojiButtonView) {
        self.emojiButtonView = [[EmojiButtonView alloc] init];
        self.emojiButtonView.delegate = self;
        self.emojiButtonView.width = self.width;
        self.emojiButtonView.height = customKeyboardHeight;
        _keyboardHeight = customKeyboardHeight;
    }
    return _emojiButtonView;
}

- (MoreButtonView *)moreButtonView
{
    if (!_moreButtonView) {
        self.moreButtonView = [[MoreButtonView alloc] init];
        self.moreButtonView.width = self.width;
        self.moreButtonView.height = customKeyboardHeight;
        _keyboardHeight = customKeyboardHeight;
    }
    return _moreButtonView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        [self layoutUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.y = keyboardFrame.origin.y - self.height;
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification
{
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.y = self.superview.height - self.height;
    }];
}

- (void)layoutUI
{
    self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 30, 30)];
    [self.leftButton setImage:[UIImage imageNamed:@"liaotian_ic_yuyin_nor"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"liaotian_ic_press"] forState:UIControlStateHighlighted];
    [self.leftButton addTarget:self action:@selector(clickLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    self.textInput = [[UITextView alloc] initWithFrame:CGRectMake(50, 5, SCREEN_WIDTH - 150, 36)];
    self.textInput.font = [UIFont systemFontOfSize:16];
    self.textInput.layer.cornerRadius = 3;
    self.textInput.layer.masksToBounds = YES;
    self.textInput.returnKeyType = UIReturnKeySend;
    self.textInput.delegate = self;
    [self addSubview:self.textInput];
    
    self.emojiButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.textInput.frame) + 10, 9, 30, 30)];
    [self.emojiButton setImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_nor"] forState:UIControlStateNormal];
    [self.emojiButton setImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_press"] forState:UIControlStateHighlighted];
    [self.emojiButton addTarget:self action:@selector(clickEmojiButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emojiButton];
    
    self.moreButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.emojiButton.frame) + 10, 9, 30, 30)];
    [self.moreButton setImage:[UIImage imageNamed:@"liaotian_ic_gengduo_nor"] forState:UIControlStateNormal];
    [self.moreButton setImage:[UIImage imageNamed:@"liaotian_ic_gengduo_press"] forState:UIControlStateHighlighted];
    [self.moreButton addTarget:self action:@selector(clickMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _textInputHeight = ceilf([self.textInput sizeThatFits:CGSizeMake(self.textInput.bounds.size.width, MAXFLOAT)].height);
    self.textInput.scrollEnabled = _textInputHeight > _TextInputMaxHeight && _TextInputMaxHeight > 0;
    if (self.textInput.scrollEnabled) {
        self.textInput.height = 5 + _TextInputMaxHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - _TextInputMaxHeight - 5 - 8;
        self.height = _TextInputMaxHeight + 15;
    } else {
        self.textInput.height = _textInputHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - _textInputHeight - 5 - 8;
        self.height = _textInputHeight + 15;
    }
    self.leftButton.y = self.emojiButton.y = self.moreButton.y = self.height - self.leftButton.height - 12;
}

- (void)emojiButtonView:(EmojiButtonView *)emojiButtonView emojiText:(NSString *)text
{
    if ([text  isEqual: deleteButtonId]) {
        [self.textInput deleteBackward];
        return;
    }
    
    NSString *string;
    if (self.textInput.text.length == 0) {
        string = @"";
    } else {
        string = self.textInput.text;
    }
    _textInputHeight = ceilf([self.textInput sizeThatFits:CGSizeMake(self.textInput.bounds.size.width, MAXFLOAT)].height);
    self.textInput.scrollEnabled = _textInputHeight > _TextInputMaxHeight && _TextInputMaxHeight > 0;
    if (self.textInput.scrollEnabled) {
        self.textInput.height = 5 + _TextInputMaxHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - _TextInputMaxHeight - 5 - 8;
        self.height = _TextInputMaxHeight + 15;
    } else {
        self.textInput.height = _textInputHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - _textInputHeight - 5 - 8;
        self.height = _textInputHeight + 15;
    }
    self.leftButton.y = self.emojiButton.y = self.moreButton.y = self.height - self.leftButton.height - 12;
    self.textInput.text = [string stringByAppendingString:text];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (_sendContent) {
            _sendContent(self.textInput.text);
        }
        textView.text = nil;
        self.textInput.height = 36;
        self.height = InputToolbarHeight;
        self.y = SCREEN_HEIGHT - _keyboardHeight - InputToolbarHeight;
        self.leftButton.y = self.emojiButton.y = self.moreButton.y = 9;
        return NO;
    }
    return YES;
}

- (void)emojiButtonView:(EmojiButtonView *)emojiButtonView sendButtonClick:(UIButton *)sender
{
    if (_sendContent) {
        _sendContent(self.textInput.text);
    }
    self.textInput.text = nil;
    self.textInput.height = 36;
    self.height = InputToolbarHeight;
    self.y = SCREEN_HEIGHT - _keyboardHeight - InputToolbarHeight;
    self.leftButton.y = self.emojiButton.y = self.moreButton.y = 9;
}

- (void)clickLeftButton
{
    [self switchToKeyboard:self.leftButtonView];
}

- (void)clickEmojiButton
{
    if (self.textInput.inputView == nil) {
        self.showKeyboardButton = YES;
        self.textInput.inputView = self.emojiButtonView;
    } else {
        self.showKeyboardButton = NO;
        self.textInput.inputView = nil;
    }
    [self.textInput endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0008 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textInput becomeFirstResponder];
    });
}

- (void)clickMoreButton
{
    [self switchToKeyboard:self.moreButtonView];
}

- (void)switchToKeyboard:(UIView *)keyboard
{
    if (self.textInput.inputView == nil) {
        self.textInput.inputView = keyboard;
    } else {
        self.textInput.inputView = nil;
    }
    [self.textInput endEditing:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0008 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.textInput becomeFirstResponder];
    });
}

- (void)setShowKeyboardButton:(BOOL)showKeyboardButton
{
    _showKeyboardButton = showKeyboardButton;
    
    // 默认的图片名
    NSString *image = @"liaotian_ic_biaoqing_nor";
    NSString *highImage = @"liaotian_ic_biaoqing_press";
    
    // 显示键盘图标
    if (showKeyboardButton) {
        image = @"liaotian_ic_jianpan_nor";
        highImage = @"liaotian_ic_jianpan_press";
    }
    
    // 设置图片
    [self.emojiButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self.emojiButton setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
}

- (void)setIsBecomeFirstResponder:(BOOL)isBecomeFirstResponder
{
    if (isBecomeFirstResponder) {
        [self.textInput becomeFirstResponder];
    } else {
        [self.textInput resignFirstResponder];
    }
}

- (void)setMorebuttonViewDelegate:(id)delegate
{
    self.moreButtonView.delegate = delegate;
}

- (void)setTextViewMaxVisibleLine:(NSInteger)textViewMaxVisibleLine
{
    _textViewMaxVisibleLine = textViewMaxVisibleLine;
    _TextInputMaxHeight = ceil(self.textInput.font.lineHeight * (textViewMaxVisibleLine - 1) + self.textInput.textContainerInset.top + self.textInput.textContainerInset.bottom);
}

@end
