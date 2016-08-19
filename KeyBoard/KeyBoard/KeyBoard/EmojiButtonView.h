//
//  EmojiButtonView.h
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EmojiButtonView;
@protocol EmojiButtonViewDelegate <NSObject>
- (void)emojiButtonView:(EmojiButtonView *)emojiButtonView text:(NSString *)text;
@end

@interface EmojiButtonView : UIView
@property(nonatomic,weak) id<EmojiButtonViewDelegate>delegate;
@end
