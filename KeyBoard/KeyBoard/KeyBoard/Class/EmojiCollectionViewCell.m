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
    self.button.userInteractionEnabled = false;
    [self.contentView addSubview:self.button];
}

- (void)setString:(NSString *)string
{
    if ([string  isEqual: deleteButtonId]) {
        [self.button setImage:[UIImage imageNamed:@"chat_ic_delete_nor"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"chat_ic_delete_press"] forState:UIControlStateHighlighted];
    } else {
        [self.button setImage:nil forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateHighlighted];
        [self.button setTitle:string forState:UIControlStateNormal];
    }
}

@end
