//
//  RatingBar.m
//  easymarketing
//
//  Created by HailongHan on 15/1/1.
//  Copyright (c) 2015年 cubead. All rights reserved.
//

#import "RatingBar.h"

@interface RatingBar (){
    float starRating;
    float lastRating;
    
    float height;
    float width;
    
    UIImage *unSelectedImage;
    UIImage *halfSelectedImage;
    UIImage *fullSelectedImage;
}

@property (nonatomic,strong) UIImageView *s1;
@property (nonatomic,strong) UIImageView *s2;
@property (nonatomic,strong) UIImageView *s3;
@property (nonatomic,strong) UIImageView *s4;
@property (nonatomic,strong) UIImageView *s5;

@property (nonatomic,weak) id<RatingBarDelegate> delegate;

@end

@implementation RatingBar

/**
 *  初始化设置未选中图片、半选中图片、全选中图片，以及评分值改变的代理（可以用
 *  Block）实现
 *
 *  @param deselectedName   未选中图片名称
 *  @param halfSelectedName 半选中图片名称
 *  @param fullSelectedName 全选中图片名称
 *  @param delegate          代理
 */
-(void)setImageDeselected:(NSString *)deselectedName halfSelected:(NSString *)halfSelectedName fullSelected:(NSString *)fullSelectedName andDelegate:(id<RatingBarDelegate>)delegate{
    
    self.delegate = delegate;
    
    unSelectedImage = [UIImage imageNamed:deselectedName];
    
    halfSelectedImage = halfSelectedName == nil ? unSelectedImage : [UIImage imageNamed:halfSelectedName];
    
    fullSelectedImage = [UIImage imageNamed:fullSelectedName];
    
    height = 0.0,width = 0.0;
    
    if (height < [fullSelectedImage size].height) {
        height = [fullSelectedImage size].height;
    }
    if (height < [halfSelectedImage size].height) {
        height = [halfSelectedImage size].height;
    }
    if (height < [unSelectedImage size].height) {
        height = [unSelectedImage size].height;
    }
    if (width < [fullSelectedImage size].width) {
        width = [fullSelectedImage size].width;
    }
    if (width < [halfSelectedImage size].width) {
        width = [halfSelectedImage size].width;
    }
    if (width < [unSelectedImage size].width) {
        width = [unSelectedImage size].width;
    }
    
    //控件宽度适配
    CGRect frame = [self frame];
    
    CGFloat viewWidth = width * 5;
    if (frame.size.width > viewWidth) {
        viewWidth = frame.size.width;
    }
    frame.size.width = viewWidth;
    frame.size.height = height;
    [self setFrame:frame];
    
    starRating = 0.0;
    lastRating = 0.0;
    
    _s1 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s2 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s3 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s4 = [[UIImageView alloc] initWithImage:unSelectedImage];
    _s5 = [[UIImageView alloc] initWithImage:unSelectedImage];
    
    
    //星星图片之间的间距
    CGFloat space = (CGFloat)(viewWidth - width*5)/6;
    
    CGFloat startX = space;
    [_s1 setFrame:CGRectMake(startX,         0, width, height)];
    startX += width + space;
    [_s2 setFrame:CGRectMake(startX,     0, width, height)];
    startX += width + space;
    [_s3 setFrame:CGRectMake(startX, 0, width, height)];
    startX += width + space;
    [_s4 setFrame:CGRectMake(startX, 0, width, height)];
    startX += width + space;
    [_s5 setFrame:CGRectMake(startX, 0, width, height)];
    
    [_s1 setUserInteractionEnabled:NO];
    [_s2 setUserInteractionEnabled:NO];
    [_s3 setUserInteractionEnabled:NO];
    [_s4 setUserInteractionEnabled:NO];
    [_s5 setUserInteractionEnabled:NO];
    
    [self addSubview:_s1];
    [self addSubview:_s2];
    [self addSubview:_s3];
    [self addSubview:_s4];
    [self addSubview:_s5];
    
}

/**
 *  设置评分值
 *
 *  @param rating 评分值
 */
-(void)displayRating:(float)rating{
    
    [_s1 setImage:unSelectedImage];
    [_s2 setImage:unSelectedImage];
    [_s3 setImage:unSelectedImage];
    [_s4 setImage:unSelectedImage];
    [_s5 setImage:unSelectedImage];
    
    if (rating >= 0.5) {
        [_s1 setImage:halfSelectedImage];
    }
    if (rating >= 1) {
        [_s1 setImage:fullSelectedImage];
    }
    if (rating >= 1.5) {
        [_s2 setImage:halfSelectedImage];
    }
    if (rating >= 2) {
        [_s2 setImage:fullSelectedImage];
    }
    if (rating >= 2.5) {
        [_s3 setImage:halfSelectedImage];
    }
    if (rating >= 3) {
        [_s3 setImage:fullSelectedImage];
    }
    if (rating >= 3.5) {
        [_s4 setImage:halfSelectedImage];
    }
    if (rating >= 4) {
        [_s4 setImage:fullSelectedImage];
    }
    if (rating >= 4.5) {
        [_s5 setImage:halfSelectedImage];
    }
    if (rating >= 5) {
        [_s5 setImage:fullSelectedImage];
    }
    
    starRating = rating;
    lastRating = rating;
    [_delegate ratingBar:self ratingChanged:rating];
}

/**
 *  获取当前的评分值
 *
 *  @return 评分值
 */
-(float)rating{
    return starRating;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesRating:touches];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesRating:touches];
}

//触发
- (void)touchesRating:(NSSet *)touches{
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    //星星图片之间的间距
    CGFloat space = (CGFloat)(self.frame.size.width - width*5)/6;
    
    float newRating = 0;
    
    if (point.x >= 0 && point.x <= self.frame.size.width) {
        
        if (point.x <= space+width*0.5f) {
            newRating = 0.5;
        }else if (point.x < space*2+width){
            newRating = 1.0;
        }else if (point.x < space*2+width*1.5){
            newRating = 1.5;
        }else if (point.x <= 3*space+2*width){
            newRating = 2.0;
        }else if (point.x <= 3*space+2.5*width){
            newRating = 2.5;
        }else if (point.x <= 4*space+3*width){
            newRating = 3.0;
        }else if (point.x <= 4*space+3.5*width){
            newRating = 3.5;
        }else if (point.x <= 5*space+4*width){
            newRating = 4.0;
        }else if (point.x <=5*space+4.5*width){
            newRating = 4.5;
        }else {
            newRating = 5.0;
        }
        
    }
    
    if (newRating != lastRating){
        [self displayRating:newRating];
    }
}

@end
