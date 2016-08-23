//
//  TiRecordingView.h
//  TiKeyboardTest
//
//  Created by Eric-WekSoft on 15/5/25.
//  Copyright (c) 2015年 Zentertain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TiRecordingState)
{
    TiShowVolumnState,
    TiShowCancelSendState,
    TiShowRecordTimeTooShort,
    TiShowRecordTimeLimited
};

@interface TiRecordingView : UIView{
    
}
@property (nonatomic,assign)TiRecordingState recordingState;

- (instancetype)initWithState:(TiRecordingState)state;

- (void)setVolume:(float)volume;

- (void)setCountDownSecond:(NSInteger)second;

@end
