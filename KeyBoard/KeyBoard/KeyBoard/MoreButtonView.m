//
//  MoreButtonScrollView.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#import "MoreButtonView.h"

@interface MoreButtonView ()
@end

@implementation MoreButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor redColor];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    CGFloat W = 50;
    CGFloat H = 50;
    
    for (NSInteger i = 0; i < 7; i ++) {
        
        CGFloat X = (((SCREEN_WIDTH - (4 * W)) / 5) * ((i % 4) + 1)) + (W * (i % 4));
        CGFloat Y = 20 + (i / 4) * (H + 35);
        UIButton *scrollViewButton = [[UIButton alloc] initWithFrame:CGRectMake(X, Y, W, H)];
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(scrollViewButton.frame.origin.x, CGRectGetMaxY(scrollViewButton.frame) + 3, scrollViewButton.frame.size.width, 20)];
        title.text = @"图片";
        title.textAlignment = NSTextAlignmentCenter;
        [scrollViewButton setBackgroundImage:[UIImage imageNamed:@"img_defaulthead_nor"] forState:UIControlStateNormal];
        scrollViewButton.tag = 10 + i;
        [scrollViewButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:title];
        [self addSubview:scrollViewButton];
    }
}

- (void)clickButton:(UIButton *)sender
{
    NSLog(@"sender%@ ",sender);
}

@end
