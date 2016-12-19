//
//  ViewController.m
//  AudioDemo
//
//  Created by ShaoFeng on 2016/12/19.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

#define ButtonWidth 80
#define SCR_W [UIScreen mainScreen].bounds.size.width
#define SCR_H [UIScreen mainScreen].bounds.size.height
#define TOTAL_NUM 0.4

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
{
    //录音
    AVAudioRecorder *_recoder;
    
    //播放
    AVAudioPlayer *_player;
    NSDictionary *_recorderSettingDict;
    
    //定时器
    NSTimer *_timer;
    
    //录音名
    NSString *_name;
    
    double _lowPassResults;
    
    AVAudioSession *_audioSession;
    
    UIView *_dynamicView;
    CAShapeLayer *_indicateLayer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    _audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError;
    //AVAudioSessionCategoryPlayAndRecord用于录音和播放
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    if(_audioSession == nil) {
        NSLog(@"Error creating session: %@", [sessionError description]);
    } else {
        [_audioSession setActive:YES error:nil];
    }
    
    [self canRecord];
    [self refreshUIWithVoicePower:0.018888];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    _name = [NSString stringWithFormat:@"%@/play.aac",path];
    
    //录音相关参数设置
    _recorderSettingDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey, //音频格式
                            [NSNumber numberWithInt:4000.0],AVSampleRateKey,//采样率
                            [NSNumber numberWithInt:2],AVNumberOfChannelsKey,//通道的数目,1单声道,2立体声
                            [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,//线性采样位数  8、16、24、32
                            @(AVAudioQualityHigh),AVEncoderAudioQualityKey, //录音质量
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端,内存组织方式
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号手否是浮点数
                            nil];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:250 / 255.0 alpha:1];
    
    UIButton *down = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W - 2 * ButtonWidth) / 3, SCR_H / 2 + 80, ButtonWidth, 40)];
    down.backgroundColor = [UIColor grayColor];
    down.layer.masksToBounds = YES;
    down.layer.cornerRadius = 5.0;
    
    [down setTitle:@"按下录音" forState:UIControlStateNormal];
    [down setTitle:@"松开完成" forState:UIControlStateHighlighted];
    [down addTarget:self action:@selector(buttonDown) forControlEvents:UIControlEventTouchDown];
    [down addTarget:self action:@selector(buttonUpInside) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:down];
    
    UIButton *play = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W - 2 * ButtonWidth) / 3 * 2 + ButtonWidth, SCR_H / 2 + 80, ButtonWidth, 40)];
    play.backgroundColor = [UIColor grayColor];
    play.layer.masksToBounds = YES;
    play.layer.cornerRadius = 5.0;
    
    [play addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    [play setTitle:@"播放" forState:UIControlStateNormal];
    [self.view addSubview:play];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCR_W / 2 - 30, 180, 60, 100)];
    imageView.image = [UIImage imageNamed:@"recording"];
    [self.view addSubview:imageView];
    _dynamicView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 40, 74)];
    _dynamicView.layer.masksToBounds = YES;
    _dynamicView.layer.cornerRadius = 20.0;
    [imageView addSubview:_dynamicView];
    
    UIButton *reset = [[UIButton alloc] initWithFrame:CGRectMake((SCR_W - ButtonWidth) / 2, SCR_H / 2 + 80 + 60, ButtonWidth, 40)];
    reset.backgroundColor = [UIColor grayColor];
    reset.layer.masksToBounds = YES;
    reset.layer.cornerRadius = 5.0;
    [reset addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
    [reset setTitle:@"复位" forState:UIControlStateNormal];
    [self.view addSubview:reset];
}

- (void)buttonDown
{
    if ([self canRecord]) {
        
        NSError *error = nil;
        _recoder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_name] settings:_recorderSettingDict error:&error];
        if (_recoder) {
            _recoder.meteringEnabled = YES;
            [_recoder prepareToRecord];
            [_recoder record];
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
        } else {
            int errorCode = CFSwapInt32HostToBig((unsigned int)[error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc] initWithTitle:nil message:@"Demo需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil] show];
        });
    }
}

- (void)levelTimer:(NSTimer *)timer
{
    [_recoder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [_recoder peakPowerForChannel:0]));
    _lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * _lowPassResults;
    [self refreshUIWithVoicePower:_lowPassResults];
    NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [_recoder averagePowerForChannel:0], [_recoder peakPowerForChannel:0],_lowPassResults);
}

- (void)buttonUpInside
{
    [_recoder stop];
    _recoder = nil;
    [_timer invalidate];
    _timer = nil;
}

- (void)playAudio
{
    NSError *playError;
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_name] fileTypeHint:AVFileTypeWAVE error:&playError];
    if (_player == nil) {
        NSLog(@"ERror creating player: %@", [playError description]);
    } else {
        [_player play];
    }
}

- (void)reset
{
    [_player stop];
    _player = nil;
    [_recoder stop];
    _recoder = nil;
    [_timer invalidate];
    _timer = nil;
    [self refreshUIWithVoicePower:0.018888];
}

-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    _audioSession = [AVAudioSession sharedInstance];
    if ([_audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [_audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                bCanRecord = YES;
            } else {
                bCanRecord = NO;
            }
        }];
    }
    return bCanRecord;
}

-(void)refreshUIWithVoicePower : (double)voicePower{
    CGFloat height = (voicePower)*(CGRectGetHeight(_dynamicView.frame) / TOTAL_NUM);
    [_indicateLayer removeFromSuperlayer];
    _indicateLayer = nil;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, CGRectGetHeight(_dynamicView.frame)-height, CGRectGetWidth(_dynamicView.frame), height) cornerRadius:0];
    _indicateLayer = [CAShapeLayer layer];
    _indicateLayer.path = path.CGPath;
    _indicateLayer.fillColor = [UIColor grayColor].CGColor;
    [_dynamicView.layer addSublayer:_indicateLayer];
}

@end
