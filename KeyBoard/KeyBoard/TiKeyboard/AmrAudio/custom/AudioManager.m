//
//  AudioManager.m
//  TiCommon
//
//  Created by Eason on 15/5/16.
//  Copyright (c) 2015年 Eason. All rights reserved.
//

#import "AudioManager.h"
#import "FileUtil.h"
#import "amrFileCodec.h"

#import "CocoaLumberjack.h"
#import <UIKit/UIKit.h>
@implementation AudioManager
SYNTHESIZE_SINGLETON_FOR_CLASS(AudioManager)
-(void)initCodec
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError* err;
//        _encoder = [OKEncoder encoderForASBD:[AudioManager monoCanonicalFormatWithSampleRate:8000] application:kOpusKitApplicationVoIP error:&err];
//        _decoder = [OKDecoder decoderForASBD:[AudioManager monoCanonicalFormatWithSampleRate:8000] error:&err];
    });
}


+(AudioStreamBasicDescription)monoCanonicalFormatWithSampleRate:(float)sampleRate
{
    AudioStreamBasicDescription asbd;
    UInt32 byteSize = 2;
    asbd.mBitsPerChannel   = 8 * byteSize;
    asbd.mBytesPerFrame    = byteSize;
    asbd.mBytesPerPacket   = byteSize;
    asbd.mChannelsPerFrame = 1;
    asbd.mSampleRate       = sampleRate;
    return asbd;
}

- (void)startRecord:(NSString*)key filePath:(NSString *)filePath{
    [self initCodec];
    if (_avPlayer) {
        [self stopPlay];
    }
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryRecord error:&sessionError];
    [session setActive:YES error:nil];
    _filePath=filePath;
    _key=key;
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat:8000], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    NSError *error;
    _recordedTmpFile=[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: _key]];
    _recorder = [[ AVAudioRecorder alloc] initWithURL:_recordedTmpFile settings:recordSetting error:&error];
    [_recorder setDelegate:self];
    [_recorder setMeteringEnabled: YES];
    [_recorder prepareToRecord];
    [_recorder recordForDuration:120];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newTimerThread) object:nil];
    [thread start];
}

- (AudioRecordResultType)stopRecord{
    [_recorder stop];
    _recorder=nil;
    _key=nil;
    [_timer invalidate];
    _timer=nil;
    _lowPassResults=0;
    
    NSData *data=[NSData dataWithContentsOfURL:_recordedTmpFile];
    //    NSTimeInterval recordTime=[AudioManager getAudioTimeWithFileSizeDouble:[data length]];
    
    NSTimeInterval recordTime=[AudioManager getAudioTimeWithData:data];
    AudioRecordResultType result=AudioRecordResultType_Success;
    
    if (recordTime<1) {
        result=AudioRecordResultType_TooShort;
    }else{
//        data = [_encoder encodeData:data];
                data=EncodeWAVEToAMR(data,1,16);
        [FileUtil saveFile:_filePath andData:data];
        result=AudioRecordResultType_Success;
    }
    
    //    [FileUtil removeFile:_recordedTmpFile.path];
    _recordedTmpFile=nil;
    _filePath=nil;
    return result;
}

- (void)cancelRecord{
    [_recorder stop];
    _recorder=nil;
    _key=nil;
    [_timer invalidate];
    _timer=nil;
    _lowPassResults=0;
    [FileUtil removeFile:_filePath];
    _filePath=nil;
}

- (void)play:(NSString*)key filePath:(NSString *)filePath playingControl:(id)control
{
    [self initCodec];
    _playingControl = control;
    if (_avPlayer) {
        [self stopPlay];
    }
    if (_recorder) {
        [self stopRecord];
    }
    _filePath=filePath;
    _key=key;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
    [session setActive:YES error:nil];
    
    NSData *data=[FileUtil getFileData:filePath];
//    data = [_decoder decodeData:data];
        data= DecodeAMRToWAVE(data);
    NSError *error;
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
    
    _avPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    _avPlayer.delegate = self;
    [_avPlayer prepareToPlay];
    //        [_avPlayer setVolume:1.0];
    [_avPlayer play];
}

-(void)revmoveObserve
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
}

-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//黑屏
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }
    else//没黑屏幕
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    if (!_key) {//没有播放了，也没有在黑屏状态下，就可以把距离传感器关了
        [self revmoveObserve];
    }
}

- (void)stopPlay{
    if (_avPlayer) {
        [_avPlayer stop];
        if (_key) {
            NSDictionary  *dic=[NSDictionary dictionaryWithObjectsAndKeys:_key,kNotify_AudioPlayStoped_ParmKey_PlayAudioKey,nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_AudioPlayStoped object:dic];
        }
    }
    _playingControl = nil;
    _avPlayer=nil;
    _filePath=nil;
    _key=nil;
    [self revmoveObserve];
}

- (NSString *)getCurrentPlay{
    return _key;
}


+ (int)getAudioTimeWithFileSize:(long long )fileSize{
    //12.2kbs.那么每秒采样的音频数据位数为:12200 / 50 = 244bit = 30.5byte,取整为31字节.取整要四舍五入,再加上一个字节的帧头,这样数据帧的大小为32字节.
    NSTimeInterval n =(double)fileSize/(32*50);
    int i =floor(n);
    return i;
}


+ (int)getAudioTimeWithFileSizeDouble:(long long )fileSize{
    NSTimeInterval n =(double)fileSize/(32*50);
    return n;
}

+ (NSTimeInterval)getAudioTimeWithData:(NSData *)data{
    NSError * error;
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    return n;
}


-(BOOL)canRecord
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    __block BOOL bCanRecord = YES;
    //- (BOOL)respondsToSelector:(SEL)Selector;在NSObject和NSProxy中都存在，在NSProxy中是一个类方法，此处使用的是它的类方法
    AVAudioSession*audioSession = [AVAudioSession sharedInstance];
    //performSelector选择执行器，requestRecordPermission：会话类别等。例子:AV音频会话类别记录,AV音频会话类别和记录,AVFoundation的一个实例方法。
    [audioSession performSelector:@selector(requestRecordPermission:)withObject:^(BOOL granted) {
        if (granted){
            bCanRecord = YES;
        }
        else{
            bCanRecord = NO;
        }
        dispatch_semaphore_signal(sema);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return bCanRecord;
}

#pragma mark -private method

- (void)newTimerThread{
    @autoreleasepool
    {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] run];
    }
}

-(void)levelTimer:(NSTimer*)timer
{
    [_recorder updateMeters];
    _lowPassResults = pow(10, (0.05 * [_recorder peakPowerForChannel:0]));
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(volumeChanged:Second:)]) {
        [self.delegate volumeChanged:_lowPassResults Second:121-_recorder.currentTime];
    }
    DDLogDebug(@"Average input: %f Peak input: %f Low pass results: %f", [_recorder averagePowerForChannel:0], [_recorder peakPowerForChannel:0], _lowPassResults);
    
}



//#pragma mark -AVAudioRecorderDelegate
//- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        DDLogDebug(@"audioRecorderDidFinishRecording.");
//
//        //结束定时器
//        [_timer invalidate];
//        _timer=nil;
//        _lowPassResults=0;
//
//        NSData *data=[FileUtil getFileData:_filePath];
//        NSTimeInterval recordTime=[AudioManager getAudioTimeWithData:data];
//        AudioRecordResultType result=AudioRecordResultType_Success;
//
//        if (recordTime<1) {
//            [FileUtil removeFile:_filePath];
//            result=AudioRecordResultType_TooShort;
//        }else{
//            data=EncodeWAVEToAMR(data,1,16);
//            [FileUtil saveFile:_filePath andData:data];
//            result=AudioRecordResultType_Success;
//        }
//
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didStopRecord:resultType:)]) {
//            [self.delegate didStopRecord:_filePath resultType:result];
//        }
//        _recorder=nil;
//        _filePath=nil;
//
//        if (_nextFilePath && isRecord) {
//            [self startRecord:_nextFilePath];
//            return ;
//        }
//        if (_nextFilePath && !isRecord) {
//            [self play:_nextFilePath];
//            return;
//        }
//
//    });
//}
//
//- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        DDLogDebug(@"audioRecorderEncodeErrorDidOccur.");
//
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didStopRecord:resultType:)]) {
//            [self.delegate didStopRecord:_filePath resultType:AudioRecordResultType_Fail];
//        }
//        _recorder=nil;
//        _filePath=nil;
//    });
//}

#pragma mark -AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (_key) {
        NSDictionary  *dic=[NSDictionary dictionaryWithObjectsAndKeys:_key,kNotify_AudioPlayStoped_ParmKey_PlayAudioKey,nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_AudioPlayStoped object:dic];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_AudioPlayFinished object:dic];
    }
    _avPlayer=nil;
    _filePath=nil;
    _key=nil;
    _playingControl=nil;
    [self revmoveObserve];
}

///* if an error occurs while decoding it will be reported to the delegate. */
//- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didPlayFinished:)]) {
//            [self.delegate didPlayFinished:_filePath];
//        }
//        _avPlayer=nil;
//        _filePath=nil;
//        if (_nextFilePath && isRecord) {
//            [self startRecord:_nextFilePath];
//        }
//    });
//}

@end
