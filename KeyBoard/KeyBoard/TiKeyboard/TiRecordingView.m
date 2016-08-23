//
//  TiRecordingView.m
//  TiKeyboardTest
//
//  Created by Eric-WekSoft on 15/5/25.
//  Copyright (c) 2015年 Zentertain. All rights reserved.
//

#define VIEW_BG_TAG                                   100

#define VIEW_RECORDING_WIDTH                          196
#define VIEW_RECORDING_HEIGHT                         196

#define VOLUMN_VIEW_TAG                               90000

#define VIEW_BGLABEL_TAG                     200
#define VIEW_PROMPT_TAG                      300
#import "TiRecordingView.h"

@interface TiRecordingView(PrivateAPI)

- (void)setupCancelSendView;
- (void)setupShowVolumnState;
- (void)setupShowRecordingTooShort;

- (void)showCancelSendState;
- (void)showVolumnState;
- (void)showRecordingTooShort;


- (float)heightForVolumn:(float)vomlun;
@end


@implementation TiRecordingView

#pragma mark - 生命周期函数

- (instancetype)initWithState:(TiRecordingState)state
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, VIEW_RECORDING_WIDTH, VIEW_RECORDING_HEIGHT);
        [self.layer setCornerRadius:10];
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        UIView* backroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VIEW_RECORDING_WIDTH, VIEW_RECORDING_HEIGHT)];
        [backroundView setBackgroundColor:[UIColor blackColor]];
        [backroundView setAlpha:0.7];
        backroundView.tag = VIEW_BG_TAG;
        [self addSubview:backroundView];
        _recordingState = TiShowVolumnState;
        [self setupShowVolumnState];
    }
    return self;
}

- (void)setRecordingState:(TiRecordingState)recordingState
{
    switch (recordingState)
    {
        case TiShowVolumnState:
            [self showVolumnState];
            break;
        case TiShowCancelSendState:
            [self showCancelSendState];
            break;
        case TiShowRecordTimeTooShort:
            [self showRecordingTooShort];
            break;
        case TiShowRecordTimeLimited:
            [self showRecordingLimited];
            break;
    }
}

#pragma mark - 内部方法

- (void)setupShowVolumnState
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(UIView*)obj tag] != VIEW_BG_TAG)
        {
            [(UIView*)obj removeFromSuperview];
        }
    }];
    UIImage* image = [UIImage imageNamed:@"ti_recording.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(50, 42, 53, 83)];
    [self addSubview:imageView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 152, VIEW_RECORDING_WIDTH, 23)];
    [prompt setBackgroundColor:[UIColor clearColor]];
    [prompt setTextColor:[UIColor whiteColor]];
    [prompt.layer setCornerRadius:2];
    [prompt setTextAlignment:NSTextAlignmentCenter];
    [prompt setFont:[UIFont systemFontOfSize:15]];
    [prompt setText:@"手指上滑 取消发送"];
    [self addSubview:prompt];
    
    UIImage* volumnImage = [UIImage imageNamed:@"RecordingSignal008.png"];
    UIImageView* volumnImageView = [[UIImageView alloc] initWithImage:volumnImage];
    [volumnImageView setFrame:CGRectMake(129, 40, 20, 100)];
    [volumnImageView setContentMode:UIViewContentModeBottom];
    [volumnImageView setClipsToBounds:YES];
    [volumnImageView setBackgroundColor:[UIColor clearColor]];
    [volumnImageView setTag:VOLUMN_VIEW_TAG];
    [self addSubview:volumnImageView];
    
}

- (void)showVolumnState
{
    if (self.recordingState != TiShowVolumnState)
    {
        [self setupShowVolumnState];
    }
    _recordingState = TiShowVolumnState;
}

- (void)setupCancelSendView
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(UIView*)obj tag] != 100)
        {
            [(UIView*)obj removeFromSuperview];
        }
    }];
    UIImage* image = [UIImage imageNamed:@"ti_cancel_send_record.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(74, 53, 45, 59)];
    [self addSubview:imageView];
    
    UIView* backgrounView = [[UIView alloc] initWithFrame:CGRectMake(28, 152, 140, 23)];
    backgrounView.backgroundColor=[UIColor colorWithRed:176/255.0 green:34/255.0 blue:33/255.0 alpha:1.0];
    [backgrounView setAlpha:0.8];
    [backgrounView.layer setCornerRadius:2];
    [backgrounView setClipsToBounds:YES];
    [self addSubview:backgrounView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(28, 152, 140, 23)];
    [prompt setBackgroundColor:[UIColor clearColor]];
    [prompt setTextColor:[UIColor whiteColor]];
    [prompt setText:@"松开手指，取消发送"];
    [prompt setFont:[UIFont systemFontOfSize:15]];
    [prompt setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:prompt];
}


- (void)showCancelSendState
{
    if (self.recordingState != TiShowCancelSendState)
    {
        [self setupCancelSendView];
    }
    _recordingState = TiShowCancelSendState;
}

- (void)setupShowRecordingTooShort
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([(UIView*)obj tag] != VIEW_BG_TAG)
        {
            [(UIView*)obj removeFromSuperview];
        }
    }];
    UIImage* image = [UIImage imageNamed:@"ti_record_too_short.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake(85, 42, 22, 83)];
    [self addSubview:imageView];
    
    UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(0, 152, VIEW_RECORDING_WIDTH, 23)];
    [prompt setBackgroundColor:[UIColor clearColor]];
    [prompt setTextColor:[UIColor whiteColor]];
    [prompt.layer setCornerRadius:2];
    [prompt setTextAlignment:NSTextAlignmentCenter];
    [prompt setFont:[UIFont systemFontOfSize:15]];
    [prompt setText:@"说话时间太短"];
    
    [self addSubview:prompt];
}

- (void)setupShowRecordingLimited
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([(UIView*)obj tag] != VIEW_BG_TAG)
            {
                [(UIView*)obj removeFromSuperview];
            }
        }];
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.tag = VIEW_BGLABEL_TAG;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:80];
        [self addSubview:label];
        
        UILabel* prompt = [[UILabel alloc] initWithFrame:CGRectMake(28, 152, 140, 23)];
        prompt.tag = VIEW_PROMPT_TAG;
        [prompt setBackgroundColor:[UIColor clearColor]];
        [prompt setTextColor:[UIColor whiteColor]];
        [prompt setText:@"手指上滑，取消发送"];
        [prompt setFont:[UIFont systemFontOfSize:15]];
        [prompt setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:prompt];
    });
    
}

- (void)showRecordingTooShort
{
    if (self.recordingState != TiShowRecordTimeTooShort)
    {
        [self setupShowRecordingTooShort];
    }
    _recordingState = TiShowRecordTimeTooShort;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.recordingState == TiShowRecordTimeTooShort)
        {
            [self setHidden:YES];
        }
    });
}

- (void)showRecordingLimited
{
    if (self.recordingState != TiShowRecordTimeLimited) {
        [self setupShowRecordingLimited];
    }
    _recordingState = TiShowRecordTimeLimited;
}


- (id)subviewWithTag:(NSInteger)tag{
    for(UIView *view in [self subviews]){
        if(view.tag == tag){
            return view;
        }
    }
    return nil;
}

- (float)heightForVolumn:(float)vomlun
{
    //0-1.6 volumn
    float height = 43.0 / 1.6 * vomlun;
    return height;
}

#pragma mark - 外部方法

- (void)setVolume:(float)volume
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_recordingState != TiShowVolumnState)
        {
            return;
        }
        
        UIImageView* volumnImageView = [self subviewWithTag:VOLUMN_VIEW_TAG];
        if(volumnImageView){
            NSString *imageName = nil;
            if (volume>0 && volume<0.2) {
                imageName = @"RecordingSignal001.png";
            }else if (volume>=0.2 && volume<0.8){
                imageName = [NSString stringWithFormat:@"RecordingSignal00%d.png",(int)(volume * 10)];
            }else{
                imageName = @"RecordingSignal008.png";
            }
            UIImage *image = [UIImage imageNamed:imageName];
            [volumnImageView setImage:image];
        }
    });
}

- (void)setCountDownSecond:(NSInteger)second
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_recordingState != TiShowRecordTimeLimited) {
            return ;
        }
        UILabel *label = [self subviewWithTag:VIEW_BGLABEL_TAG];
        UILabel *prompt = [self subviewWithTag:VIEW_PROMPT_TAG];
        if (label) {
            if (second>0&&second<=10) {
                [label setText:[NSString stringWithFormat:@"%ld",(long)second]];
            }else if (second == 0){
                [label setText:@"!"];
                if (prompt) {
                    [prompt setText:@"录音超时"];
                }
            }
        }
    });
}

#pragma mark - UI操作

@end
