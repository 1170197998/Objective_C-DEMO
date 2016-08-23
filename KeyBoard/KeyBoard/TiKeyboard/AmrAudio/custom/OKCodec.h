//
//  OKCodec.h
//  OpusKit
//
//  Created by Christopher Ballinger on 2/17/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int32_t, OpusKitSampleRate) {
    kOpusKitSampleRate_8000 = 8000,
    kOpusKitSampleRate_12000 = 12000,
    kOpusKitSampleRate_16000 = 16000,
    kOpusKitSampleRate_24000 = 24000,
    kOpusKitSampleRate_48000 = 48000
};

typedef NS_ENUM(int, OpusKitChannels) {
    kOpusKitChannelsMono = 1,
    kOpusKitChannelsStereo = 2
};

@interface OKCodec : NSObject

@property (nonatomic, readonly) OpusKitSampleRate sampleRate;
@property (nonatomic, readonly) OpusKitChannels numberOfChannels;

- (id) initWithSampleRate:(OpusKitSampleRate)sampleRate numberOfChannels:(OpusKitChannels)channels;

@end
