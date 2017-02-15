//
//  UIView+extension.h
//  AlipayScanQRCode
//
//  Created by ShaoFeng on 2017/2/15.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "UIView+extension.h"

@implementation UIView (xtension)

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect temp = self.frame;
    temp.size.height = height;
    self.frame = temp;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect temp = self.frame;
    temp.size.width = width;
    self.frame = temp;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect temp = self.frame;
    temp.origin.y = y;
    self.frame = temp;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect temp = self.frame;
    temp.origin.x = x;
    self.frame = temp;
}

@end
