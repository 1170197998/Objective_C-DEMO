//
//  TiExpressionView.h
//  TiKeyboardTest
//
//  Created by Eric on 15/5/1.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TiExpressionViewDelegate <NSObject>

- (void)outputExpressionText:(NSString *)expStr;

- (void)outputEmojiText:(NSString *)expStr;

- (void)deletePreChar;

- (void)sendExpression;

@end

@interface TiExpressionView : UIView<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UIScrollView *_expressionScrollView;
    UIScrollView *_emjoyScrollView;
    
    UIScrollView *_expressionTabScrollView;
    UIButton *_sendBtn;

}
@property (nonatomic,assign) id<TiExpressionViewDelegate>delegate;
@property (nonatomic,strong) NSArray *expressionDataArray;
@property (nonatomic,strong) NSArray *emjoyDataArray;

- (void)setSendBtnEnable:(BOOL)enable;

@end
