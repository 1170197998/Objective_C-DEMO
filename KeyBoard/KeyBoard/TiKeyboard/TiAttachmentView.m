//
//  TiAttachmentView.m
//  TiKeyboardTest
//
//  Created by Eric on 15/4/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width


#import "TiAttachmentView.h"
//#import "TiUIMacro.h"

@implementation TiAttachmentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:243/255. green:244/255. blue:246/255. alpha:1]];
        
        _topLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
        [_topLine setBackgroundColor:[UIColor colorWithRed:219/255. green:220/255. blue:221/255. alpha:1]];
        [self addSubview:_topLine];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 185)];
//        [_scrollView setContentSize:CGSizeMake(ScreenWidth*2, 185)];
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, 185)];

        [_scrollView setBackgroundColor:[UIColor clearColor]];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
        [self addSubview:_scrollView];
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 185, ScreenWidth, 15)];
        [_pageControl setBackgroundColor:[UIColor clearColor]];
        [_pageControl setNumberOfPages:2];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:138/255. green:139/255. blue:140/255. alpha:1]];
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithRed:185/255. green:186/255. blue:187/255. alpha:1]];
        [_pageControl setCurrentPage:0];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
        _pageControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
//        [self addSubview:_pageControl];
        
        CGFloat space = (ScreenWidth+1-(59*4))/5;
        
        for (int i = 1; i <= 3 ; i++) {
            int x = 0;
            int y = 15;
            int p = 0;
            
            if ( i > 0 && i <= 4) {
                x = i;
                y = 15;
                p = 0;
            }else if ( i > 4 && i <= 8 ) {
                x = i-4;
                y = 15+59+24;
                p = 0;
            }else if ( i > 8 ){
                x = i-8;
                y = 15;
                p = ScreenWidth;
            }
            
            UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
            [temp setBackgroundColor:[UIColor clearColor]];
            [temp setBackgroundImage:[UIImage imageNamed:@"sharemore_other.png"] forState:UIControlStateNormal];
            [temp setBackgroundImage:[UIImage imageNamed:@"sharemore_other_HL.png"] forState:UIControlStateHighlighted];
            [temp setFrame:CGRectMake(x*space+59*(x-1)+p, y, 59, 59)];
            [temp addTarget:self action:@selector(attachmentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel *tempLabel = [[UILabel alloc]init];
            [tempLabel setBackgroundColor:[UIColor clearColor]];
            [tempLabel setTextAlignment:NSTextAlignmentCenter];
            [tempLabel setFont:[UIFont systemFontOfSize:10]];
            [tempLabel setFrame:CGRectMake(x*space+59*(x-1)+p, temp.frame.origin.y+temp.frame.size.height, 59, 24)];
            
            switch (i) {
                case 1://照片
                {
                    [temp setImage:[UIImage imageNamed:@"send_ic_pic_nor.png"] forState:UIControlStateNormal];
                    [temp setImage:[UIImage imageNamed:@"send_ic_pic_press.png"] forState:UIControlStateHighlighted];
                    [tempLabel setText:@"照片"];
                    [temp setTag:AttachmentSelectedStauts_Photo];
                }
                    break;
                case 2://拍摄
                {
                    [temp setImage:[UIImage imageNamed:@"send_ic_camera_nor.png"] forState:UIControlStateNormal];
                    [temp setImage:[UIImage imageNamed:@"send_ic_camera_press.png"] forState:UIControlStateHighlighted];
                    [tempLabel setText:@"拍摄"];
                    [temp setTag:AttachmentSelectedStauts_Video];
                }
                    break;
//                case 3://小视频
//                {
//                    [temp setImage:[UIImage imageNamed:@"sharemore_sight.png"] forState:UIControlStateNormal];
//                    [temp setImage:[UIImage imageNamed:@"sharemore_sight.png"] forState:UIControlStateHighlighted];
//                    [tempLabel setText:@"小视频"];
//                    [temp setTag:AttachmentSelectedStauts_Sight];
//                }
//                    break;
//                case 4://视频聊天
//                {
//                    [temp setImage:[UIImage imageNamed:@"sharemore_videovoip.png"] forState:UIControlStateNormal];
//                    [temp setImage:[UIImage imageNamed:@"sharemore_videovoip.png"] forState:UIControlStateHighlighted];
//                    [tempLabel setText:@"视频聊天"];
//                    [temp setTag:AttachmentSelectedStauts_VideoVoip];
//                }
//                    break;
//                case 5://收藏
//                {
//                    [temp setImage:[UIImage imageNamed:@"sharemore_myfav.png"] forState:UIControlStateNormal];
//                    [temp setImage:[UIImage imageNamed:@"sharemore_myfav.png"] forState:UIControlStateHighlighted];
//                    [tempLabel setText:@"收藏"];
//                    [temp setTag:AttachmentSelectedStauts_MyFav];
//                }
//                    break;
//                case 6://位置
//                {
//                    [temp setImage:[UIImage imageNamed:@"sharemore_location.png"] forState:UIControlStateNormal];
//                    [temp setImage:[UIImage imageNamed:@"sharemore_location.png"] forState:UIControlStateHighlighted];
//                    [tempLabel setText:@"位置"];
//                    [temp setTag:AttachmentSelectedStauts_Location];
//                }
//                    break;
                case 3://名片
                {
                    [temp setImage:[UIImage imageNamed:@"send_ic_card_nor.png"] forState:UIControlStateNormal];
                    [temp setImage:[UIImage imageNamed:@"send_ic_card_nor.png"] forState:UIControlStateHighlighted];
                    [tempLabel setText:@"名片"];
                    [temp setTag:AttachmentSelectedStauts_FriendCard];
                }
                    break;
//                case 8://语音输入
//                {
//                    [temp setImage:[UIImage imageNamed:@"sharemore_voiceinput.png"] forState:UIControlStateNormal];
//                    [temp setImage:[UIImage imageNamed:@"sharemore_voiceinput.png"] forState:UIControlStateHighlighted];
//                    [tempLabel setText:@"语音输入"];
//                    [temp setTag:AttachmentSelectedStauts_VoiceInput];
//                }
//                    break;
//                case 9://实时对讲机
//                {
//                    [temp setImage:[UIImage imageNamed:@"sharemore_wxtalk.png"] forState:UIControlStateNormal];
//                    [temp setImage:[UIImage imageNamed:@"sharemore_wxtalk.png"] forState:UIControlStateHighlighted];
//                    [tempLabel setText:@"实时对讲机"];
//                    [temp setTag:AttachmentSelectedStauts_WXTalk];
//                }
                    break;
                    
                default:
                    break;
            }
            
            [_scrollView addSubview:temp];
            [_scrollView addSubview:tempLabel];
        }
    
        
        
    }
    return self;
}

#pragma mark -UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x == 0) {
        [_pageControl setCurrentPage:0];
    }else{
        [_pageControl setCurrentPage:1];
    }
}

#pragma mark -UI操作

- (void)attachmentBtnClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(attachmentClicked:)]) {
        [self.delegate attachmentClicked:sender.tag];
    }
}

- (void)pageControlChanged:(id)sender{
    NSInteger pageNum = [_pageControl currentPage];
    if (pageNum == 0) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    }
}

@end
