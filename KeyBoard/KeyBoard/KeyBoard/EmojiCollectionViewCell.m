//
//  EmojiCollectionViewCell.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/19.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "EmojiCollectionViewCell.h"

@interface EmojiCollectionViewCell ()
@property (nonatomic,strong)UIButton *button;
@end

@implementation EmojiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.button = [[UIButton alloc] initWithFrame:CGRectInset(self.contentView.bounds, 12, 5)];
//    self.button.backgroundColor = [UIColor whiteColor];
    //拦截button自带的点击
    self.button.userInteractionEnabled = false;
    [self.contentView addSubview:self.button];
}

- (void)setString:(NSString *)string
{
    [self.button setTitle:string forState:UIControlStateNormal];
}

@end
