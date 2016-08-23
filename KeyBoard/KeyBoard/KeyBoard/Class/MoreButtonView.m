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

        self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeImages title:@"Images"];
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeCamera title:@"Camera"];
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeFile title:@"File"];
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeContact title:@"Contact"];
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeLocation title:@"Location"];
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeSeal title:@"Seal"];
    [self addButtonWithIcon:@"img_defaulthead_nor" highIcon:@"img_defaulthead_nor" tag:MoreButtonViewButtonTypeEmail title:@"Email"];
}

- (void)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)heighIcon tag:(int )tag title:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:heighIcon] forState:UIControlStateNormal];
    [self addSubview:button];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:14];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSMutableArray *mArrayButton = [NSMutableArray array];
    NSMutableArray *mArrayLabel = [NSMutableArray array];

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArrayButton addObject:view];
        } else if ([view isKindOfClass:[UILabel class]]) {
            [mArrayLabel addObject:view];
        }
    }
    
    CGFloat buttonW = 55;
    CGFloat buttonH = buttonW;
    for (NSInteger i = 0; i < mArrayButton.count; i ++) {
        UIButton *button = mArrayButton[i];
        UILabel *label = [mArrayLabel objectAtIndex:i];
        CGFloat X = (((SCREEN_WIDTH - (4 * buttonW)) / 5) * ((i % 4) + 1)) + (buttonW * (i % 4));
        CGFloat Y = 15 + (i / 4) * (buttonH + 35);
        button.frame = CGRectMake(X, Y, buttonW, buttonH);
        label.frame = CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame) + 3, button.frame.size.width + 5, 20);
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(moreButtonView:didClickButton:)]) {
        [_delegate moreButtonView:self didClickButton:(MoreButtonViewButtonType)sender.tag];
    }
}

@end
