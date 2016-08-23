//
//  CircleKeyboard.m
//  MeetYou
//
//  Created by Cocav on 16/5/11.
//  Copyright © 2016年 Eason. All rights reserved.
//

#import "CircleKeyboard.h"
#import "Masonry.h"
#import "TiUIMacro.h"
#import "TiUIColor.h"

@interface CircleKeyboard ()<GrowingTextDelegate,UITextViewDelegate>
@property BOOL systemKeyboardShown;

@end


@implementation CircleKeyboard

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange:) name:UITextViewTextDidChangeNotification object:nil];
        // 背景
        _bgImageView = [[UIImageView alloc]init];
        [_bgImageView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bgImageView];
        [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(self);
        }];
        
        
        _topLine = [[UIImageView alloc]init];
        [_topLine setBackgroundColor:[UIColor colorWithRed:194/255. green:194/255. blue:197/255. alpha:1]];
        [self addSubview:_topLine];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(0.5f);
        }];
        
        [self setBackgroundColor:[UIColor colorWithRed:244/255. green:244/255. blue:246/255. alpha:1]];
        

        
//        UIImage *textViewBackground = [[UIImage imageNamed:@"SendTextViewBkg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
//        _textViewBGImageView = [[UIImageView alloc] initWithImage:textViewBackground];
//        [self addSubview:_textViewBGImageView];
        
        _textView = [[MBAutoGrowingTextView alloc] init];
        _textView.growDelegate = self;
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5);
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(5,0,5,5);
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        _textView.layer.cornerRadius = 3;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont systemFontOfSize:16.];
        _textView.textColor = [UIColor colorWithRed:88/255. green:88/255. blue:88/255. alpha:1.];
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.height.mas_lessThanOrEqualTo(100);
            make.height.mas_greaterThanOrEqualTo(30);
            make.left.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-93);
        }];
        [_textView initialize];
        
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [TiUIColor getC23Color];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(10);
            make.height.mas_equalTo(20);
        }];
        
        _sendTextAndExpressionBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendTextAndExpressionBtn setBackgroundColor:[UIColor grayColor]];
        _sendTextAndExpressionBtn.layer.cornerRadius = 3;
        _sendTextAndExpressionBtn.userInteractionEnabled = NO;
        _sendTextAndExpressionBtn.layer.masksToBounds = YES;
        [_sendTextAndExpressionBtn setTitle:@"发送" forState:(UIControlStateNormal)];
        [_sendTextAndExpressionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_sendTextAndExpressionBtn addTarget:self action:@selector(sendTextAndExpressionBtnClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_sendTextAndExpressionBtn];
        [_sendTextAndExpressionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(self).offset(-13);
            make.size.mas_equalTo(CGSizeMake(45,30));
        }];
        
        
        _toolExpressionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolExpressionBtn setBackgroundColor:[UIColor clearColor]];
        [_toolExpressionBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_nor.png"] forState:UIControlStateNormal];
        [_toolExpressionBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_press.png"] forState:UIControlStateHighlighted];
        [_toolExpressionBtn addTarget:self action:@selector(toolExpressionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolExpressionBtn];
        [_toolExpressionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-60);
            make.bottom.mas_equalTo(self).offset(-14);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        
        
        _toolExpressionKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolExpressionKeyboardBtn setBackgroundColor:[UIColor clearColor]];
        [_toolExpressionKeyboardBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_jianpan_nor.png"] forState:UIControlStateNormal];
        [_toolExpressionKeyboardBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_jianpan_press.png"] forState:UIControlStateHighlighted];
        [_toolExpressionKeyboardBtn setHidden:YES];
        [_toolExpressionKeyboardBtn addTarget:self action:@selector(toolExpressionKeyboardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolExpressionKeyboardBtn];
        [_toolExpressionKeyboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.right.mas_equalTo(_toolExpressionBtn);
        }];
        
        
        dispatch_async(dispatch_get_main_queue(),^{
            _expressionView = [[TiExpressionView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 201)];
            [_expressionView setTag:119119];
            [_expressionView setDelegate:self];
            _expressionView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
            [[self mainWindow] addSubview:_expressionView];
        });
        _isExpShow = NO;
        _isKeyboardShow = NO;
    }
    return self;
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_expressionView removeFromSuperview];
    _expressionView = nil;
}

-(BOOL)becomeFirstResponder
{
    [self.window bringSubviewToFront:self];
    [self.window bringSubviewToFront:_expressionView];
    return [_textView becomeFirstResponder];
}

- (void)resetKeyboard
{
    if(!_systemKeyboardShown)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
    [_textView resignFirstResponder];
    [self resetExpression];
    _keboardInputType = Text_InputType;
    _isKeyboardShow = NO;
    [self setSendTextAndExpressionBtnColorAccordingToTextViewText];
}

/*
 * 重置输入框
 */
- (void)resetTextView{
    [_textView resignFirstResponder];
}

/*
 * 重置表情
 */
- (void)resetExpression{
    [UIView animateWithDuration:0.25f animations:^{
        [_toolExpressionBtn setHidden:NO];
        [_toolExpressionKeyboardBtn setHidden:YES];
        [_expressionView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 201)];
    }];
}


/*
 * 设置Keyboard为文字状态
 */
- (void)setTextStatus{
    _isKeyboardShow = YES;
    //显示隐藏相关UI
    [_textViewBGImageView setHidden:NO];
    [_textView setHidden:NO];
    [_toolExpressionBtn setHidden:NO];
    [_toolExpressionKeyboardBtn setHidden:YES];
    [_textView layoutSubviews];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_textView.frame.size.height+40);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
        {
            [_delegate TiKeyboardFrameChanged];
        }
    }];
    
    [_textView becomeFirstResponder];
    //重置表情
    [self resetExpression];
    
    _keboardInputType = Text_InputType;
}

/*
 * 设置Keyboard为表情状态
 */
- (void)setExpressionStatus{
    _isKeyboardShow = YES;
    
    if (_keboardInputType == Text_InputType) {//文字转表情
        _isExpShow = YES;
        //显示隐藏相关UI
        [_textViewBGImageView setHidden:NO];
        [_textView setHidden:NO];
        [_toolExpressionBtn setHidden:YES];
        [_toolExpressionKeyboardBtn setHidden:NO];
        [_textView resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:7];
        [_expressionView setFrame:CGRectMake(0, ScreenHeight - 201 , ScreenWidth, 201)];
        [UIView commitAnimations];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-201);
        }];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
            if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
            {
                [_delegate TiKeyboardFrameChanged];
            }
        }];
    }else if (_keboardInputType == Expression_InputType){//表情转表情
        //无此情况
    }
    _keboardInputType = Expression_InputType;
    
    if (_textView.text.length > 0) {
        [_expressionView setSendBtnEnable:YES];
    }else{
        [_expressionView setSendBtnEnable:NO];
    }
}



/*
 * 设置Keyboard从表情到文字
 */
- (void)setExpressionToTextStatus{
    _isKeyboardShow = YES;
    _isExpShow = NO;
    [self resetExpression];
    [_textView becomeFirstResponder];
    
    //显示隐藏相关UI
    [_textViewBGImageView setHidden:NO];
    [_textView setHidden:NO];
    [_toolExpressionBtn setHidden:NO];
    [_toolExpressionKeyboardBtn setHidden:YES];
    _keboardInputType = Text_InputType;
    if(!_systemKeyboardShown)
    {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        }];
    }
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}



#pragma mark - UI操作

//切换键盘按钮
- (void)toolKeyboardBtnClicked:(id)sender{
    [self setTextStatus];
}

//切换表情按钮
- (void)toolExpressionBtnClicked:(id)sender{
    [self setExpressionStatus];
}

//表情切换到文字
- (void)toolExpressionKeyboardBtnClicked:(id)sender{
    [self setExpressionToTextStatus];
}


#pragma mark - 键盘通知

-(void) keyboardWillShow:(NSNotification *)note{
    _isKeyboardShow = YES;
    _systemKeyboardShown = YES;
    _keboardInputType = Text_InputType;
    [self resetExpression];
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    keyboardBounds = [self.superview convertRect:keyboardBounds toView:nil];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardBounds.size.height);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self layoutIfNeeded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
        {
            [_delegate TiKeyboardFrameChanged];
        }
    }];
}

-(void) keyboardWillHide:(NSNotification *)note{
    if(!_systemKeyboardShown)
        return;
    _systemKeyboardShown = NO;
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    [UIView commitAnimations];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:duration.floatValue animations:^{
        [self layoutIfNeeded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
        {
            [_delegate TiKeyboardFrameChanged];
        }
    }];
}


//- (void)shouldReturn{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardSendText:)]) {
//        if (![_textView.text isEqualToString:@""]) {
//            [self.delegate TiKeyboardSendText:_textView.text];
//            _textView.text = @"";
//            [self resetKeyboard];
//        }
//    }
//}

-(void)sizeWillChange:(CGFloat)newHeight
{
    //    CGFloat
    //    CGFloat newBottom = self.frame.origin.y + newHeight - ScreenHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(newHeight+40);
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.35f animations:^{
        [self layoutIfNeeded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
        {
            [_delegate TiKeyboardFrameChanged];
        }
    }];
}

#pragma mark - TiExpressionViewDelegate

- (void)outputExpressionText:(NSString *)expStr{
    [_textView addEmotion:expStr];
    [_expressionView setSendBtnEnable:YES];
}

- (void)deletePreChar{
    [_textView removePreChar];
    if (_textView.text.length > 0) {
        [_expressionView setSendBtnEnable:YES];
    }else{
        [_expressionView setSendBtnEnable:NO];
    }
}

-(void)outputEmojiText:(NSString *)expStr
{
    [_textView addText:expStr];
    [_expressionView setSendBtnEnable:YES];
    
}

- (void)sendExpression{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardSendText:)]) {
        if (![_textView.text isEqualToString:@""]) {
            [self.delegate TiKeyboardSendText:_textView.text];
            _textView.text = @"";
            [_expressionView setSendBtnEnable:NO];
        }
    }
}

- (void)setNameLabelText:(NSString *)string
{
    if (string) {
        _nameLabel.text = [NSString stringWithFormat:@"回复: %@",string];
    }else{
        _nameLabel.text = @"评论: ";
    }
}

- (void)sendTextAndExpressionBtnClicked:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardSendText:)]) {
        [self.delegate TiKeyboardSendText:_textView.text];
        _textView.text = @"";
        [self resetKeyboard];
    }
}
//
//- (void)textViewTextChange:(NSNotification *)notify
//{
//    [self setSendTextAndExpressionBtnColorAccordingToTextViewText];
//}

- (void)textViewDidChange:(UITextView *)textView
{
    [self setSendTextAndExpressionBtnColorAccordingToTextViewText];
}

  
- (void)setSendTextAndExpressionBtnColorAccordingToTextViewText
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *tempString = [_textView.text stringByTrimmingCharactersInSet:set];
    if ([tempString length] != 0) {
        _sendTextAndExpressionBtn.backgroundColor = [TiUIColor getC26Color];
        _sendTextAndExpressionBtn.userInteractionEnabled = YES;
    }else{
        _sendTextAndExpressionBtn.backgroundColor = [UIColor grayColor];
        _sendTextAndExpressionBtn.userInteractionEnabled = NO;
    }
}

- (void)cleanTextViewContent
{
    _textView.text = @"";
}


@end
