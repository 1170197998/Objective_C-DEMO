//
//  CircleKeyboard.h
//  MeetYou
//
//  Created by Cocav on 16/5/11.
//  Copyright © 2016年 Eason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiExpressionView.h"
#import "TiKeyboard.h"
#import "MBAutoGrowingTextView.h"

@protocol  CircleKeyboardDelegate<NSObject>

- (void)TiKeyboardFrameChanged;

- (void)TiKeyboardSendText:(NSString *)textStr;

@end


@interface CircleKeyboard : UIView<TiExpressionViewDelegate>

{
    TiKeyboardInputType _keboardInputType;
    
    UIImageView *_bgImageView;
    
    UIImageView *_topLine;
        
    UIImageView *_textViewBGImageView;
    MBAutoGrowingTextView *_textView;
    
    UIButton *_toolExpressionBtn;
    UIButton *_toolExpressionKeyboardBtn;
    UIButton *_sendTextAndExpressionBtn;
    TiExpressionView *_expressionView;
    UILabel *_nameLabel;
    BOOL _isExpShow;
    
}
@property(nonatomic,strong)MBAutoGrowingTextView *textView;
@property(nonatomic,assign)BOOL isKeyboardShow;//是否为文字输入模式，表情输入模式
@property (nonatomic,weak)id<CircleKeyboardDelegate>delegate;
- (void)resetKeyboard;

- (void)setNameLabelText:(NSString*)string;

- (void)cleanTextViewContent;

@end
