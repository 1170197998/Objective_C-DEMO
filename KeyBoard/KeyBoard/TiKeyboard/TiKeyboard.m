//
//  TiKeyboard.m
//  TiKeyboardTest
//
//  Created by Eric on 15/4/29.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "TiKeyboard.h"
#import "TiUIMacro.h"
#import "MessageModel.h"
#import "MessageManager.h"
#import "TiUtil.h"
#import "FileUtil.h"
#import "FilePathManager.h"
#import "Masonry.h"
@interface TiKeyboard()<GrowingTextDelegate>
@property BOOL systemKeyboardShown;
@end
@implementation TiKeyboard

#pragma mark - 生命周期函数

- (instancetype)init{
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioTimeOutAndSend:) name:@"AudioTimeOutAndSendMessage" object:nil];

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
        _textView.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5);
        _textView.scrollIndicatorInsets = UIEdgeInsetsMake(5,0,5,5);
        _textView.returnKeyType = UIReturnKeySend;
        _textView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
        _textView.layer.cornerRadius = 3;
        _textView.layer.masksToBounds = YES;
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(30);
            make.height.mas_lessThanOrEqualTo(100);
            make.height.mas_greaterThanOrEqualTo(30);
            make.left.mas_equalTo(42);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-2*(35+3)-5); 
        }];
//        [_textViewBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.mas_equalTo(_textView);
//            make.top.mas_equalTo(5);
//            make.bottom.mas_equalTo(-5);
//        }];
        [_textView initialize];
        
        _sendVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendVoiceBtn setBackgroundColor:[UIColor clearColor]];
        [_sendVoiceBtn setTitleColor:[UIColor colorWithRed:86/255. green:87/255. blue:89/255. alpha:1] forState:UIControlStateNormal];
        [_sendVoiceBtn setTitleColor:[UIColor colorWithRed:86/255. green:87/255. blue:89/255. alpha:1] forState:UIControlStateHighlighted];
        [_sendVoiceBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [_sendVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_sendVoiceBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_sendVoiceBtn setBackgroundImage:[[UIImage imageNamed:@"VoiceBtn_Black.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:15] forState:UIControlStateNormal];
        [_sendVoiceBtn setBackgroundImage:[[UIImage imageNamed:@"VoiceBtn_BlackHL.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:15] forState:UIControlStateHighlighted];
        [_sendVoiceBtn setHidden:YES];
        [self addSubview:_sendVoiceBtn];
        [_sendVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(42);
            make.bottom.mas_equalTo(-5);
            make.height.mas_equalTo(45.33);
            make.right.mas_equalTo(-2*(35+3)-3);
        }];
        
        _recordGestureRecognizer = [[RecordGestureRecognizer alloc] initWithTarget:self action:nil];
        __weak TiKeyboard* weakSelf = self;
        _recordGestureRecognizer.touchDown = ^{
            [weakSelf p_record:nil];
            weakSelf.userInteractionEnabled = NO;
        };
        
        _recordGestureRecognizer.moveInside = ^{
            [weakSelf p_endCancelRecord:nil];
            weakSelf.userInteractionEnabled = YES;
        };
        
        _recordGestureRecognizer.moveOutside = ^{
            [weakSelf p_willCancelRecord:nil];
        };
        
        _recordGestureRecognizer.touchEnd = ^(BOOL inside){
            if (inside)
            {
                [weakSelf p_sendRecord:nil];
            }
            else
            {
                [weakSelf p_cancelRecord:nil];
            }
            weakSelf.userInteractionEnabled = YES;
        };
        [_sendVoiceBtn addGestureRecognizer:_recordGestureRecognizer];
        
        
        
        _toolVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolVoiceBtn setBackgroundColor:[UIColor clearColor]];
        [_toolVoiceBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_yuyin_nor.png"] forState:UIControlStateNormal];
        [_toolVoiceBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_press.png"] forState:UIControlStateHighlighted];
        
        [_toolVoiceBtn addTarget:self action:@selector(toolVoiceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolVoiceBtn];
        [_toolVoiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(5);
            make.bottom.mas_equalTo(self).offset(-9);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        
        _toolKeyboardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolKeyboardBtn setBackgroundColor:[UIColor clearColor]];
        [_toolKeyboardBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_jianpan_nor.png"] forState:UIControlStateNormal];
        [_toolKeyboardBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_jianpan_press.png"] forState:UIControlStateHighlighted];
        [_toolKeyboardBtn addTarget:self action:@selector(toolKeyboardBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolKeyboardBtn setHidden:YES];
        [self addSubview:_toolKeyboardBtn];
        [_toolKeyboardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_toolVoiceBtn);
        }];
        
        _toolAttachmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolAttachmentBtn setBackgroundColor:[UIColor clearColor]];
        [_toolAttachmentBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_gengduo_nor.png"] forState:UIControlStateNormal];
        [_toolAttachmentBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_gengduo_press.png"] forState:UIControlStateHighlighted];
        [_toolAttachmentBtn addTarget:self action:@selector(toolAttachmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolAttachmentBtn];
        [_toolAttachmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-5);
            make.bottom.mas_equalTo(_toolKeyboardBtn);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        _toolExpressionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_toolExpressionBtn setBackgroundColor:[UIColor clearColor]];
        [_toolExpressionBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_nor.png"] forState:UIControlStateNormal];
        [_toolExpressionBtn setBackgroundImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_press.png"] forState:UIControlStateHighlighted];
        [_toolExpressionBtn addTarget:self action:@selector(toolExpressionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_toolExpressionBtn];
        [_toolExpressionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_toolAttachmentBtn).offset(-38);
            make.bottom.mas_equalTo(_toolAttachmentBtn);
            make.size.mas_equalTo(_toolAttachmentBtn);
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
            _attachmentView = [[TiAttachmentView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 201)];
            [_attachmentView setTag:110110];
            [_attachmentView setDelegate:self];
            _attachmentView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
            [[self mainWindow] addSubview:_attachmentView];
            _recordingView = [[TiRecordingView alloc]initWithState:TiShowVolumnState];
            [_recordingView setHidden:YES];
            [_recordingView setCenter:CGPointMake([self mainWindow].center.x, [self mainWindow].center.y)];
            [[self mainWindow] addSubview:_recordingView];
            
        });        
        _isExpAndAttShow = NO;
        _isKeyboardShow = NO;
        
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[AudioManager sharedAudioManager] setDelegate:nil];
    [_expressionView removeFromSuperview];
    _expressionView = nil;
    [_attachmentView removeFromSuperview];
    _attachmentView = nil;
    [_recordingView removeFromSuperview];
    _recordingView = nil;
}

- (void)setKeyboardText:(NSString *)str
{
    _textView.text = str;
}

- (NSString *)getkeyboardText
{
    return _textView.text;
}

#pragma mark - 外部方法
- (NSArray<NSString*>*) atList
{
    return _textView.atList;
}

- (void)addLink:(NSString*) text value:(NSString*)value
{
    [_textView addLink:text value:value];
    [_textView becomeFirstResponder];
}

- (void)resetKeyboard{
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
    [self resetAttachment];
    _keboardInputType = Text_InputType;
    _isKeyboardShow = NO;
}
/*
 * 重置输入框
 */
- (void)resetTextView{
    [_textView resignFirstResponder];
}

/*
 * 重置附件
 */
- (void)resetAttachment{
    [UIView animateWithDuration:0.25f animations:^{
        [_attachmentView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 201)];
    }];
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
 * 设置Keyboard为语音状态
 */
- (void)setVoiceStatus{
    _isKeyboardShow = NO;
    //显示隐藏相关UI
    [_toolVoiceBtn setHidden:YES];
    [_toolKeyboardBtn setHidden:NO];
    [_textViewBGImageView setHidden:YES];
    [_toolExpressionBtn setHidden:NO];
    [_toolExpressionKeyboardBtn setHidden:YES];
    [_textView setHidden:YES];
    [_sendVoiceBtn setHidden:NO];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55.33);
        if(!_systemKeyboardShown)
        {
            make.bottom.mas_equalTo(0);
        }
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    if(_systemKeyboardShown)
    {
        [_textView resignFirstResponder];
    }
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
        {
            [_delegate TiKeyboardFrameChanged];
        }
    }];
    //重置附件
    [self resetAttachment];
    //重置表情
    [self resetExpression];
    
    _keboardInputType = Voice_InputType;
}

/*
 * 设置Keyboard为文字状态
 */
- (void)setTextStatus{
    _isKeyboardShow = YES;
    //显示隐藏相关UI
    [_toolKeyboardBtn setHidden:YES];
    [_toolVoiceBtn setHidden:NO];
    [_sendVoiceBtn setHidden:YES];
    [_textViewBGImageView setHidden:NO];
    [_textView setHidden:NO];
    [_toolExpressionBtn setHidden:NO];
    [_toolExpressionKeyboardBtn setHidden:YES];
    [_textView layoutSubviews];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_textView.frame.size.height+20);
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
    //重置附件
    [self resetAttachment];
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
        _isExpAndAttShow = YES;
        //显示隐藏相关UI
        [_toolKeyboardBtn setHidden:YES];
        [_toolVoiceBtn setHidden:NO];
        [_sendVoiceBtn setHidden:YES];
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
    }else if (_keboardInputType == Voice_InputType){//语音转表情
        _isExpAndAttShow = YES;
        //显示隐藏相关UI
        [_toolKeyboardBtn setHidden:YES];
        [_toolVoiceBtn setHidden:NO];
        [_sendVoiceBtn setHidden:YES];
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
        [_textView layoutSubviews];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_textView.frame.size.height+20);
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
    }else if (_keboardInputType == Attachment_InputType){//附件转表情
        [self resetExpression];
        [self resetAttachment];
        [_toolExpressionBtn setHidden:YES];
        [_toolExpressionKeyboardBtn setHidden:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:7];
        [_expressionView setFrame:CGRectMake(0, ScreenHeight - 201 , ScreenWidth, 201)];
        [UIView commitAnimations];
    }
    [self resetAttachment];
    _keboardInputType = Expression_InputType;
    
    if (_textView.text.length > 0) {
        [_expressionView setSendBtnEnable:YES];
    }else{
        [_expressionView setSendBtnEnable:NO];
    }
}

/*
 * 设置Attachment显示隐藏
 */
- (void)setAttachmentView{
    _isKeyboardShow = YES;
    if (_keboardInputType == Text_InputType) {//文字转附件
        _isExpAndAttShow = YES;
        
        //显示隐藏相关UI
        [_toolKeyboardBtn setHidden:YES];
        [_toolVoiceBtn setHidden:NO];
        [_sendVoiceBtn setHidden:YES];
        [_textViewBGImageView setHidden:NO];
        [_textView setHidden:NO];
        [_toolExpressionBtn setHidden:NO];
        [_toolExpressionKeyboardBtn setHidden:YES];
        [_textView resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:7];
        [_attachmentView setFrame:CGRectMake(0, ScreenHeight - 201 , ScreenWidth, 201)];
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
        _keboardInputType = Attachment_InputType;
        
    }else if (_keboardInputType == Voice_InputType){//语音转附件
        //显示隐藏相关UI
        [_toolKeyboardBtn setHidden:YES];
        [_toolVoiceBtn setHidden:NO];
        [_sendVoiceBtn setHidden:YES];
        [_textViewBGImageView setHidden:NO];
        [_textView setHidden:NO];
        [_toolExpressionBtn setHidden:NO];
        [_toolExpressionKeyboardBtn setHidden:YES];
        [_textView resignFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:7];
        [_attachmentView setFrame:CGRectMake(0, ScreenHeight - 201 , ScreenWidth, 201)];
        [UIView commitAnimations];
        [_textView layoutSubviews];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(_textView.frame.size.height+20);
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
        
        _keboardInputType = Attachment_InputType;
        
    }else if (_keboardInputType == Expression_InputType){//表情转附件
        [self resetExpression];
        [self resetAttachment];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:7];
        [_attachmentView setFrame:CGRectMake(0, ScreenHeight - 201 , ScreenWidth, 201)];
        [UIView commitAnimations];
        
        _keboardInputType = Attachment_InputType;
    }else if (_keboardInputType == Attachment_InputType){//附件转文本
        [_textView becomeFirstResponder];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:7];
        [_attachmentView setFrame:CGRectMake(0, ScreenHeight , ScreenWidth, 201)];
        [UIView commitAnimations];
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
        _keboardInputType = Text_InputType;
    }
}


/*
 * 设置Keyboard从表情到文字
 */
- (void)setExpressionToTextStatus{
    _isKeyboardShow = YES;
    _isExpAndAttShow = NO;
    [self resetExpression];
    [self resetAttachment];
    [_textView becomeFirstResponder];
    
    //显示隐藏相关UI
    [_toolKeyboardBtn setHidden:YES];
    [_toolVoiceBtn setHidden:NO];
    [_textViewBGImageView setHidden:NO];
    [_textView setHidden:NO];
    [_toolExpressionBtn setHidden:NO];
    [_toolExpressionKeyboardBtn setHidden:YES];
    [_sendVoiceBtn setHidden:YES];
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

//切换语音按钮
- (void)toolVoiceBtnClicked:(id)sender{
    [self setVoiceStatus];
}

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

//切换附件按钮
- (void)toolAttachmentBtnClicked:(id)sender{
    [self setAttachmentView];
}

#pragma mark - 键盘通知

-(void) keyboardWillShow:(NSNotification *)note{
    _isKeyboardShow = YES;
    _systemKeyboardShown = YES;
    _keboardInputType = Text_InputType;
    [self resetExpression];
    [self resetAttachment];
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


- (void)shouldReturn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardSendText:)]) {
        if (![_textView.text isEqualToString:@""]) {
            [self.delegate TiKeyboardSendText:_textView.text];
            _textView.text = @"";
        }
    }
}

-(void)shouldAt{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardShouldAt:)])
    {
        [self.delegate TiKeyboardShouldAt:^(NSString *ret,NSString* value) {
            if(value)
            {
                [_textView addLink:ret value:value];
                [_textView becomeFirstResponder];
            }
            else
            {
                [_textView addText:ret];
            }
        }];
    }
}

-(void)sizeWillChange:(CGFloat)newHeight
{
    //    CGFloat
    //    CGFloat newBottom = self.frame.origin.y + newHeight - ScreenHeight;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(newHeight+20);
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardFrameChanged)])
    {
        [_delegate TiKeyboardFrameChanged];
    }
}


- (void)audioTimeOutAndSend:(NSNotification*)notify{
    [self setVoiceBtnStatus:SendVoice_StartStatus];
    BOOL canRecord = [[AudioManager sharedAudioManager] canRecord];
    if (!canRecord) {
        return;
    }
    AudioRecordResultType result = [[AudioManager sharedAudioManager] stopRecord];
    if (result == AudioRecordResultType_Success) {
        [_recordingView setHidden:YES];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardSendVoice:)]) {
            [self.delegate TiKeyboardSendVoice:_voiceMessageModel];
        }
    }else if (result == AudioRecordResultType_TooShort){
        [_recordingView setRecordingState:TiShowRecordTimeTooShort];
    }
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

#pragma mark - TiAttachmentViewDelegate

- (void)attachmentClicked:(AttachmentSelectedStauts)status{
    if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardAttachmentSelected:)]) {
        [self.delegate TiKeyboardAttachmentSelected:status];
    }
}

#pragma mark - 录音相关操作


- (void)p_record:(UIButton*)button{
    BOOL canRecord = [[AudioManager sharedAudioManager] canRecord];
    if (!canRecord) {
        return;
    }
    
    [self setVoiceBtnStatus:SendVoice_RecordStatus];
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:TiShowVolumnState];
    
    //    NSString *originID=[TiUtil getUUIDString];
    if (_voiceMessageModel) {
        _voiceMessageModel = nil;
    }
    _voiceMessageModel = [[MessageModel alloc]initSendMessageWithAccountID:_accountID messageType:MessageType_Audio];
    _voiceMessageModel.attachmentDesc = [FileDescription new];
    _voiceMessageModel.attachmentDesc.localUrl = [NSURL URLWithString:[FilePathManager createFilePath:_voiceMessageModel.messageID fileIdType:FileType_Audio extension:nil]];
    [[AudioManager sharedAudioManager] setDelegate:self];
    [[AudioManager sharedAudioManager] startRecord:_voiceMessageModel.messageID filePath:[_voiceMessageModel.attachmentDesc getLocalUrlString]];
}

- (void)p_endCancelRecord:(UIButton*)button{
    [self setVoiceBtnStatus:SendVoice_RecordStatus];
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:TiShowVolumnState];
}

- (void)p_willCancelRecord:(UIButton*)button{
    [self setVoiceBtnStatus:SendVoice_WillCancelStatus];
    [_recordingView setHidden:NO];
    [_recordingView setRecordingState:TiShowCancelSendState];
}

- (void)p_sendRecord:(UIButton*)button{
    [self setVoiceBtnStatus:SendVoice_StartStatus];
    BOOL canRecord = [[AudioManager sharedAudioManager] canRecord];
    if (!canRecord) {
        return;
    }
    AudioRecordResultType result = [[AudioManager sharedAudioManager] stopRecord];
    if (result == AudioRecordResultType_Success) {
        [_recordingView setHidden:YES];
        //发送语音
        //        _voiceMessageModel.attachmentModel.attachmentSize = [FileUtil getFileSize:_voiceMessageModel.attachmentModel.attachmentPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(TiKeyboardSendVoice:)]) {
            [self.delegate TiKeyboardSendVoice:_voiceMessageModel];
        }
    }else if (result == AudioRecordResultType_TooShort){
        //太短
        [_recordingView setRecordingState:TiShowRecordTimeTooShort];
    }
}

- (void)p_cancelRecord:(UIButton*)button{
    [self setVoiceBtnStatus:SendVoice_StartStatus];
    [[AudioManager sharedAudioManager] cancelRecord];
    [_recordingView setHidden:YES];
    
}



- (void)setVoiceBtnStatus:(TiSendVoiceBtnStatus)status{
    switch (status) {
        case SendVoice_StartStatus:{
            [_sendVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
            [_sendVoiceBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
            [_sendVoiceBtn setHighlighted:NO];
        }
            break;
        case SendVoice_RecordStatus:{
            [_sendVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
            [_sendVoiceBtn setTitle:@"松开 结束" forState:UIControlStateHighlighted];
            [_sendVoiceBtn setHighlighted:YES];
        }
            break;
        case SendVoice_WillCancelStatus:{
            [_sendVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
            [_sendVoiceBtn setTitle:@"松开手指 取消发送" forState:UIControlStateHighlighted];
            [_sendVoiceBtn setHighlighted:YES];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - AudioManagerDelegate


- (void)didPlayFinished:(NSString*)filePath{
    
}

- (void)volumeChanged:(double)volume Second:(NSInteger)second{
    if (second<11 && second>=0) {
        [_recordingView setRecordingState:(TiShowRecordTimeLimited)];
        [_recordingView setCountDownSecond:second];
        if (second==0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"AudioTimeOutAndSendMessage" object:nil];
        }
    }else{
        [_recordingView setVolume:volume];
    }
}


@end
