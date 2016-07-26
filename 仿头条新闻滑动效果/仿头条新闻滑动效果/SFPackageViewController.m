//
//  SFPackageViewController.m
//  仿头条新闻滑动效果
//
//  Created by Cocav on 16/3/20.
//  Copyright © 2016年 cocav. All rights reserved.
//

#import "SFPackageViewController.h"

@implementation SFPackageViewController

#pragma mark - 根据传进来的view设置偏移的位置

+ (void)setMoveScrollViewContentOffsetWithCurrentClickView:(UIView *)currentClickview andMoveScrollView:(UIScrollView *)moveScrollView
{
    if(moveScrollView.contentSize.width - moveScrollView.frame.size.width < 0)
        return;
    CGFloat x = currentClickview.frame.origin.x - (moveScrollView.frame.size.width - currentClickview.frame.size.width)/2;
    if(x > (moveScrollView.contentSize.width - moveScrollView.frame.size.width))
    {
        x = moveScrollView.contentSize.width - moveScrollView.frame.size.width;
    }
    else if(x < 0)
    {
        x = 0;
    }
    [moveScrollView setContentOffset:CGPointMake(x, currentClickview.frame.origin.y) animated:YES];
}
@end
