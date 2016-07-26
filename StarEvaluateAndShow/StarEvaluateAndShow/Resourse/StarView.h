//
//  StarView.h
//  CustomCellDemo
//
//  Created by ShaoFeng on 13-6-9.
//  Copyright (c) 2013年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView
{
    //背景图
    UIImageView *backgroundImageView;
    //前景图
    UIImageView *foregroundImageView;
}
//设置星级
-(void)setStar:(CGFloat)star;
@end
