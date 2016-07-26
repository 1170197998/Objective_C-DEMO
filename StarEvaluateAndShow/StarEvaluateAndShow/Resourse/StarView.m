//
//  StarView.m
//  CustomCellDemo
//
//  Created by ShaoFeng on 13-6-9.
//  Copyright (c) 2013年 Cocav. All rights reserved.
//

#import "StarView.h"

@implementation StarView

-(void)createImage
{
    backgroundImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"StarsBackground"]];
    backgroundImageView.frame=CGRectMake(0, 0, 240, 40);
    backgroundImageView.contentMode=UIViewContentModeLeft;
    foregroundImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_evaluateall"]];
    foregroundImageView.frame=CGRectMake(0, 0, 240, 40);
    //设置内容的对齐方式
    foregroundImageView.contentMode=UIViewContentModeLeft;
    //如果子视图超出父视图大小时被裁剪掉 
    foregroundImageView.clipsToBounds=YES;
    [self addSubview:backgroundImageView];
    [self addSubview:foregroundImageView];
    self.backgroundColor=[UIColor clearColor];
}
//给用xib创建这个类对象时用的方法
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        [self createImage];
    }
    return self;
}
-(void)setStar:(CGFloat)star
{
    CGRect frame=backgroundImageView.frame;
    
    frame.size.width=frame.size.width*(star/5);
    
    foregroundImageView.frame=frame;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createImage];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
