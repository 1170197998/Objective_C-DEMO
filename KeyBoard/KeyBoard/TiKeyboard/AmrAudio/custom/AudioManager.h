//
//  AudioManager.h
//  TiCommon
//
//  Created by Eason on 15/5/16.
//  Copyright (c) 2015年 Eason. All rights reserved.
//

#if __has_feature(objc_arc)

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
return shared##classname; \
}

#else

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)shared##classname;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
return shared##classname; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}

#endif

#import <Foundation/Foundation.h>
//#import "SynthesizeSingleton.h"
#import <AVFoundation/AVFoundation.h>
//#import "OKEncoder.h"
//#import "OKDecoder.h"
#define kNotify_AudioPlayStoped  @"kNotify_AudioPlayStoped"
#define kNotify_AudioPlayStoped_ParmKey_PlayAudioKey @"kNotify_AudioPlayStoped_ParmKey_PlayAudioKey"
#define kNotify_AudioPlayFinished  @"kNotify_AudioPlayFinished"

typedef enum AudioRecordResultType{
    AudioRecordResultType_Success= 0,
    //    AudioRecordResultType_Fail = 1,
    //    AudioRecordResultType_NoPermissions = 2,
    AudioRecordResultType_TooShort = 3
}AudioRecordResultType;


@protocol AudioManagerDelegate<NSObject>
@optional
//- (void)didPlayFinished:(NSString*)filePath;
- (void)volumeChanged:(double)volume Second:(NSInteger)second;
//- (void)countDown:(NSInteger)second;
@end

@interface AudioManager : NSObject<AVAudioRecorderDelegate,AVAudioPlayerDelegate>{
    AVAudioRecorder *_recorder;
    AVAudioPlayer *_avPlayer;
    NSString *_filePath;
    NSString *_key;
    double _lowPassResults;
    NSTimer *_timer;
    NSURL * _recordedTmpFile;
//    OKEncoder* _encoder;
//    OKDecoder* _decoder;
}
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(AudioManager)

@property(nonatomic,weak)id<AudioManagerDelegate>delegate;
@property(nonatomic,weak)id playingControl;

- (BOOL)canRecord;

- (void)startRecord:(NSString*)key filePath:(NSString *)filePath;

- (AudioRecordResultType)stopRecord;

- (void)cancelRecord;

- (void)play:(NSString*)key filePath:(NSString *)filePath playingControl:(id)control;

- (void)stopPlay;

- (NSString *)getCurrentPlay;

//+ (int)getAudioTime:(NSString *)filePath;
//+ (int)getAudioTimeWithData:(NSData *)data;
+ (int)getAudioTimeWithFileSize:(long long )fileSize;
@end
