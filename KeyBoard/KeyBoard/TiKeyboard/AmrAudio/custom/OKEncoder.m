//
//  OpusEncoder.m
//  OpusKit
//
//  Created by Christopher Ballinger on 2/17/14.
//
//

#import "OKEncoder.h"
#import "opus.h"

static const int kNumberOfSamplesPerChannel = 160;

@interface OKEncoder()
@property (nonatomic) OpusEncoder *encoder;
@property (nonatomic) uint8_t *encoderOutputBuffer;
@property (nonatomic) NSUInteger encoderBufferLength;
@end

@implementation OKEncoder

- (void) dealloc {
    if (_encoder) {
        opus_encoder_destroy(_encoder);
    }
    if (_encoderOutputBuffer) {
        free(_encoderOutputBuffer);
    }
}

- (void) setBitrate:(NSUInteger)bitrate {
    if (!_encoder) {
        return;
    }
    _bitrate = bitrate;
    opus_encoder_ctl(_encoder, OPUS_SET_BITRATE(bitrate));
}

- (int) opusApplicationForOpusKitApplication:(OpusKitApplication)application {
    switch (application) {
        case kOpusKitApplicationVoIP:
            return OPUS_APPLICATION_VOIP;
        case kOpusKitApplicationAudio:
            return OPUS_APPLICATION_AUDIO;
        case kOpusKitApplicationRestrictedLowDelay:
            return OPUS_APPLICATION_RESTRICTED_LOWDELAY;
        default:
            return -1;
            break;
    }
}

- (BOOL) setupEncoderWithApplication:(OpusKitApplication)application error:(NSError *__autoreleasing *)error {
    if (self.encoder) {
        return YES;
    }
    int app = [self opusApplicationForOpusKitApplication:application];
    int opusError = OPUS_OK;
    self.encoder = opus_encoder_create(self.sampleRate, self.numberOfChannels, app, &opusError);
//    opus_encoder_ctl(self.encoder, OPUS_SET_BANDWIDTH(OPUS_BANDWIDTH_SUPERWIDEBAND));
    //Use Hard CBR(fix rate)
    opus_encoder_ctl(self.encoder, OPUS_SET_VBR(0));
    opus_encoder_ctl(self.encoder, OPUS_SET_BITRATE(12800));
    opus_encoder_ctl(self.encoder, OPUS_SET_SIGNAL(OPUS_SIGNAL_VOICE));
    if (opusError != OPUS_OK) {
        return NO;
    }
    
    self.encoderBufferLength = 4000;
    self.encoderOutputBuffer = malloc(_encoderBufferLength * sizeof(uint8_t));
    memset(self.encoderOutputBuffer, 0, 4000);
    return YES;
}
+ (OKEncoder*) encoderForASBD:(AudioStreamBasicDescription)absd application:(OpusKitApplication)application error:(NSError *__autoreleasing *)error {
    OKEncoder *encoder = [[OKEncoder alloc] initWithSampleRate:absd.mSampleRate numberOfChannels:absd.mChannelsPerFrame];
    encoder.inputASBD = absd;
    BOOL success = [encoder setupEncoderWithApplication:application error:error];
    if (success) {
        return encoder;
    }
    return nil;
}

int SkipCaffHead(char* buf);

- (NSData*) encodeData:(NSData *)data{
    char* buf = (char*)data.bytes;
    int maxLen = (int)data.length;
    int nPos = 0;
    nPos += SkipCaffHead(buf);
    if (nPos>=maxLen) {
        return nil;
    }
    
    //这时取出来的是纯pcm数据
    buf += nPos;
    opus_int16 *shortdata = (opus_int16 *)buf;
    int encoded = 0;
    NSMutableData* ret = [[NSMutableData alloc]init];
    int i = 0;
    while(encoded + (kNumberOfSamplesPerChannel << 1) < data.length)
    {
        int16_t returnValue = opus_encode(_encoder, shortdata, kNumberOfSamplesPerChannel, _encoderOutputBuffer, _encoderBufferLength);
        if (returnValue < 0) {
            return nil;
        }
        NSLog(@"%d times encode",++i);
        encoded+=(kNumberOfSamplesPerChannel << 1);
        shortdata+=kNumberOfSamplesPerChannel;
        [ret appendData:[NSData dataWithBytes: &returnValue length: sizeof(int16_t)]];
        [ret appendBytes:_encoderOutputBuffer length:returnValue];
    }
    return ret;
}


@end
