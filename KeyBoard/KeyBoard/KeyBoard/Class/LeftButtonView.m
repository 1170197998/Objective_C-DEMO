
//
//  LeftButtonView.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "LeftButtonView.h"
#import "UIView+Extension.h"
@interface LeftButtonView ()
@property (nonatomic,strong)UIView *leftView;
@property (nonatomic,strong)UIImageView *mainView;
@property (nonatomic,strong)UIView *rightView;

@end

@implementation LeftButtonView

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
    self.mainView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mianView"]];
    self.mainView.x = SCREEN_WIDTH / 2 - 40;
    self.mainView.y = 60;
    self.mainView.width = self.mainView.height = 80;
    [self addSubview:self.mainView];
    self.mainView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.mainView addGestureRecognizer:swipe];
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longpress:)];
    [self.mainView addGestureRecognizer:longpress];

}

- (void)swipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"zuo");
    } else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"you");
    }UIGestureRecognizer
}

- (void)longpress:(UILongPressGestureRecognizer *)recognizer
{
    NSLog(@"long");
}

@end
