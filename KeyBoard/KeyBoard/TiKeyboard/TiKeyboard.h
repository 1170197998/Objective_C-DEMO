//
//  TiKeyboard.h
//  TiKeyboardTest
//
//  Created by Eric on 15/4/29.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiAttachmentView.h"
#import "TiExpressionView.h"
#import "RecordGestureRecognizer.h"
#import "TiRecordingView.h"
#import "AudioManager.h"
#import "MBAutoGrowingTextView.h"
@class MessageModel;

typedef NS_ENUM(NSUInteger, TiKeyboardInputType) {
    Voice_InputType,
    Text_InputType,
    Expression_InputType,
    Attachment_InputType
};

typedef NS_ENUM(NSUInteger, TiSendVoiceBtnStatus) {
    SendVoice_StartStatus,
    SendVoice_RecordStatus,
    SendVoice_WillCancelStatus,
};

@protocol TiKeyboardDelegate <NSObject>

- (void)TiKeyboardFrameChanged;

- (void)TiKeyboardSendText:(NSString *)textStr;

- (void)TiKeyboardShouldAt:(void(^)(NSString* ret,NSString* value)) result;

- (void)TiKeyboardAttachmentSelected:(AttachmentSelectedStauts)status;

- (void)TiKeyboardSendVoice:(MessageModel *)voiceMessageModel;

@end



@interface TiKeyboard : UIView <TiExpressionViewDelegate,TiAttachmentViewDelegate,AudioManagerDelegate> {
    TiKeyboardInputType _keboardInputType;
    
    UIImageView *_bgImageView;
    
    UIImageView *_topLine;
    
    UIButton *_toolKeyboardBtn;
    UIButton *_toolVoiceBtn;
    
    UIImageView *_textViewBGImageView;
    MBAutoGrowingTextView *_textView;
    
    UIButton *_sendVoiceBtn;
    RecordGestureRecognizer *_recordGestureRecognizer;
    TiRecordingView *_recordingView;
    
    UIButton *_toolExpressionBtn;
    UIButton *_toolExpressionKeyboardBtn;
    TiExpressionView *_expressionView;
    
    UIButton *_toolAttachmentBtn;
    TiAttachmentView *_attachmentView;
    
    BOOL _isExpAndAttShow;
    
    MessageModel *_voiceMessageModel;
}
@property(nonatomic,assign)long long accountID;
@property(nonatomic,assign)id<TiKeyboardDelegate>delegate;
@property(nonatomic,assign)BOOL isKeyboardShow;//是否为文字输入模式，表情输入模式，附件打开模式
- (NSArray<NSString*>*) atList;
- (void)resetKeyboard;
- (void)addLink:(NSString*) text value:(NSString*)value;
- (NSString *)getkeyboardText;
- (void)setKeyboardText:(NSString *)str;
@end
