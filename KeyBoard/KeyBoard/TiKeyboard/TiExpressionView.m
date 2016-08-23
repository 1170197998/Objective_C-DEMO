//
//  TiExpressionView.m
//  TiKeyboardTest
//
//  Created by Eric on 15/5/1.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import "TiExpressionView.h"
#import "TiUIMacro.h"
#import "TiEmotion.h"
#define DELETE_BTN_TAG 10000

@implementation TiExpressionView
#pragma mark -生命周期函数

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化表情数据
        [self setExpressionData];
        [self setEmjoyData];
        
        //构造UI
        [self setBackgroundColor:[UIColor colorWithRed:249/255. green:249/255. blue:249/255. alpha:1]];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, frame.size.height-37-30)];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setContentSize:CGSizeMake(ScreenWidth*2, frame.size.height-37-30)];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, _scrollView.frame.size.height, ScreenWidth, 30)];
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        [_pageControl setNumberOfPages:4];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:138/255. green:139/255. blue:140/255. alpha:1]];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:185/255. green:186/255. blue:187/255. alpha:1]];
        [_pageControl setCurrentPage:0];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pageControl];
        
        [self createExpressionScrollView];
        
        [self createEmjoyScrollView];
        
        //tab栏
        UIImageView *bottomLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-37, ScreenWidth, 0.5)];
        [bottomLine setBackgroundColor:[UIColor colorWithRed:178/255. green:177/255. blue:178/255. alpha:1]];
        [self addSubview:bottomLine];
        
        _expressionTabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,frame.size.height-37,ScreenWidth,37)];
        
        UIButton *expressionBtn = [self createTabBtnWithImageName:@"emotion0001.png"];
        [expressionBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [expressionBtn setFrame:CGRectMake(0, 0, 60, 37)];
        [expressionBtn setTag:0];
        [expressionBtn setSelected:YES];
        [expressionBtn addTarget:self action:@selector(tabBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
        [_expressionTabScrollView addSubview:expressionBtn];
        
        UIButton *favBtn = [self createTabBtnWithImageName:nil];
        [favBtn setTitle:_emjoyDataArray[0] forState:UIControlStateNormal];
        [favBtn setFrame:CGRectMake(expressionBtn.frame.size.width, 0, 60, 37)];
        [favBtn setTag:1];
        [favBtn addTarget:self action:@selector(tabBtnClicekd:) forControlEvents:UIControlEventTouchUpInside];
        [_expressionTabScrollView addSubview:favBtn];
        //
        //        UIButton *settingBtn = [self createTabBtnWithImageName:@"EmotionsSetting.png"];
        //        [settingBtn setFrame:CGRectMake(favBtn.frame.origin.x+favBtn.frame.size.width, 0, 60, 37)];
        //        [_expressionTabScrollView addSubview:settingBtn];
        
        [_expressionTabScrollView setContentSize:CGSizeMake(ScreenWidth+1, 37)];
        [self addSubview:_expressionTabScrollView];
        
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setBackgroundColor:[UIColor clearColor]];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnGrey.png"] forState:UIControlStateNormal];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnBlueHL.png"] forState:UIControlStateHighlighted];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"EmotionsSendBtnBlue.png"] forState:UIControlStateSelected];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_sendBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
        [_sendBtn setTitleColor:[UIColor colorWithRed:124/255. green:124/255. blue:124/255. alpha:1] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1] forState:UIControlStateSelected];
        [_sendBtn setFrame:CGRectMake(ScreenWidth-70, frame.size.height-37, 70, 37)];
        [_sendBtn addTarget:self action:@selector(tabSendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_sendBtn setEnabled:NO];
        [self addSubview:_sendBtn];
        
        UIImageView *topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [topLine setBackgroundColor:[UIColor colorWithRed:219/255. green:219/255. blue:220/255. alpha:1]];
        [self addSubview:topLine];
    }
    return self;
}

#pragma mark -内部方法

- (UIButton *)createTabBtnWithImageName:(NSString *)imageName{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBg.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBg.png"] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageNamed:@"EmotionsBagTabBgFocus.png"] forState:UIControlStateSelected];
    return btn;
}

- (void)createExpressionScrollView{
    _expressionScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _scrollView.frame.size.height)];
    [_expressionScrollView setPagingEnabled:YES];
    [_expressionScrollView setShowsHorizontalScrollIndicator:NO];
    [_expressionScrollView setShowsVerticalScrollIndicator:NO];
    [_expressionScrollView setDelegate:self];
    [_expressionScrollView setContentSize:CGSizeMake(ScreenWidth*4, _scrollView.frame.size.height)];
    [_expressionScrollView setBackgroundColor:[UIColor clearColor]];
    
    int page = (int)_expressionDataArray.count / 20;
    for (int i = 0 ; i < page ; i++) {
        UIView *eView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth,134)];
        [eView setBackgroundColor:[UIColor clearColor]];
        [self createExpressionWhitPage:i andView:eView];
        [_expressionScrollView addSubview:eView];
    }
    [_scrollView addSubview:_expressionScrollView];
}

- (void)createExpressionWhitPage:(int)page andView:(UIView *)view{
    CGFloat space = (ScreenWidth - 32 * 7) / 8;
    for (int i=0; i<3; i++) {
        for (int y=0; y<7; y++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*32 + (y+1)*space, i*32+12*(i+1), 32, 32)];
            if ((i * 7 + y + page * 20) > 100) {
                return;
            }else{
                if (i * 7 + y == 20 || (i * 7 + y + page * 20) == 100)
                {
                    [button setImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
                    button.tag=DELETE_BTN_TAG;
                    [button addTarget:self action:@selector(expClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:button];
                }
                else
                {
                    NSString *eName = [NSString stringWithFormat:@"emotion%04d.png",(i*7+y+(page*20))+1];
                    [button setTag:i*7+y+(page*20)];
                    [button setImage:[UIImage imageNamed:eName] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(expClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:button];
                }
            }
        }
    }
}

- (void)createEmjoyScrollView{
    _emjoyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, _scrollView.frame.size.height)];
    [_emjoyScrollView setPagingEnabled:YES];
    [_emjoyScrollView setShowsHorizontalScrollIndicator:NO];
    [_emjoyScrollView setShowsVerticalScrollIndicator:NO];
    [_emjoyScrollView setDelegate:self];
    [_emjoyScrollView setContentSize:CGSizeMake(ScreenWidth*2, _scrollView.frame.size.height)];
    [_emjoyScrollView setBackgroundColor:[UIColor clearColor]];
    
    int page = (int)_emjoyDataArray.count / 20 + 1;
    for (int i = 0 ; i < page ; i++) {
        UIView *eView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth,134)];
        [eView setBackgroundColor:[UIColor clearColor]];
        [self createEmjoyWhitPage:i andView:eView];
        [_emjoyScrollView addSubview:eView];
    }
    [_scrollView addSubview:_emjoyScrollView];
}

- (void)createEmjoyWhitPage:(int)page andView:(UIView *)view{
    CGFloat space = (ScreenWidth - 32 * 7) / 8;
    for (int i=0; i<3; i++) {
        for (int y=0; y<7; y++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*32 + (y+1)*space, i*32+12*(i+1), 32, 32)];
            if ((i * 7 + y + page * 20) > _emjoyDataArray.count - 1) {
                return;
            }else{
                if (i * 7 + y == 20 || (i * 7 + y + page * 20) == 100)
                {
                    [button setImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
                    button.tag=DELETE_BTN_TAG;
                    [button addTarget:self action:@selector(expClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:button];
                }
                else
                {
                    NSString *eName = [_emjoyDataArray objectAtIndex:i*7+y+(page*20)];
                    [button setTag:i*7+y+(page*20)];
                    [button setTitle:eName forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(expClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [view addSubview:button];
                }
            }
        }
    }
}

#pragma mark -外部方法

- (void)setSendBtnEnable:(BOOL)enable{
    [_sendBtn setSelected:enable];
    [_sendBtn setEnabled:enable];
}

#pragma mark -UI操作

- (void)tabBtnClicekd:(UIButton *)sender{
    for (UIView *view in _expressionTabScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *temp = (UIButton *)view;
            [temp setSelected:NO];
        }
    }
    [sender setSelected:YES];
    [_scrollView setContentOffset:CGPointMake(ScreenWidth*sender.tag, 0) animated:NO];
    if (_scrollView.contentOffset.x >= 320) {
        int pageCount = 2;
        [_pageControl setNumberOfPages:pageCount];
        int pageIndex = _emjoyScrollView.contentOffset.x/_emjoyScrollView.frame.size.width;
        [_pageControl setCurrentPage:pageIndex];
    }else{
        int pageCount = 4;
        [_pageControl setNumberOfPages:pageCount];
        int pageIndex = _expressionScrollView.contentOffset.x/_expressionScrollView.frame.size.width;
        [_pageControl setCurrentPage:pageIndex];
    }
}

- (void)tabSendBtnClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendExpression)]) {
        [self.delegate sendExpression];
    }
}


- (void)pageControlChanged:(id)sender{
    NSInteger pageNum = [_pageControl currentPage];
    
    if(_pageControl.numberOfPages == 4)
    {
        [_expressionScrollView setContentOffset:CGPointMake(_expressionScrollView.frame.size.width*pageNum, 0)  animated:YES];
    }
    else
    {
        [_emjoyScrollView setContentOffset:CGPointMake(_emjoyScrollView.frame.size.width*pageNum, 0)  animated:YES];
    }
}

- (void)expClicked:(UIButton *)sender{
    if (sender.tag == DELETE_BTN_TAG) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deletePreChar)]) {
            [self.delegate deletePreChar];
        }
        return;
    }
    if (_scrollView.contentOffset.x >= 320) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(outputEmojiText:)]) {
            [self.delegate outputEmojiText:[_emjoyDataArray objectAtIndex:sender.tag]];
        }
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(outputExpressionText:)]) {
            [self.delegate outputExpressionText:[_expressionDataArray objectAtIndex:sender.tag]];
        }
    }
    
}


#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView.contentOffset.x >= 320) {
        int pageCount = 2;
        [_pageControl setNumberOfPages:pageCount];
        int pageIndex = _emjoyScrollView.contentOffset.x/_emjoyScrollView.frame.size.width;
        [_pageControl setCurrentPage:pageIndex];
    }else{
        int pageCount = 4;
        [_pageControl setNumberOfPages:pageCount];
        int pageIndex = _expressionScrollView.contentOffset.x/_expressionScrollView.frame.size.width;
        [_pageControl setCurrentPage:pageIndex];
    }
    
    int tempTag = _scrollView.contentOffset.x / 320;
    
    for (UIView *view in _expressionTabScrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *temp = (UIButton *)view;
            [temp setSelected:NO];
            if (temp.tag == tempTag) {
                [temp setSelected:YES];
            }else{
                [temp setSelected:NO];
            }
        }
    }
}

#pragma mark -表情数据

- (void)setExpressionData{
    _expressionDataArray = [TiEmotion sharedTiEmotion].emotions;
}

- (void)setEmjoyData{
    _emjoyDataArray = @[@"\U0001F601",
                        @"\U0001F604",
                        @"\U0001F606",
                        @"\U0001F60A",
                        @"\U0001F60B",
                        @"\U0001F60D",
                        @"\U0001F60E",
                        @"\U0001F60F",
                        @"\U0001F611",
                        @"\U0001F613",
                        @"\U0001F616",
                        @"\U0001F618",
                        @"\U0001F617",
                        @"\U0001F620",
                        @"\U0001F621",
                        @"\U0001F624",
                        @"\U0001F627",
                        @"\U0001F62E",
                        @"\U0001F634",
                        @"\U0001F62D",
                        
                        @"\U0001F631",
                        @"\U0001F632",
                        @"\U0001F636",
                        @"\U0001F637",
                        @"\U0000263A",
                        @"\U0001F47F",
                        @"\U0001F48B",
                        @"\U00002764",
                        @"\U0001F44C",
                        @"\U0000261D",
                        @"\U0001F44E",
                        @"\U0001F44D",
                        @"\U0000270A",
                        @"\U0000270C",
                        @"0️⃣",
                        @"1️⃣",
                        @"2️⃣",
                        @"3️⃣",
                        @"4️⃣",
                        @"5️⃣",
                        @"6️⃣",
                        @"7️⃣",
                        @"8️⃣",
                        @"9️⃣"];
}




@end
