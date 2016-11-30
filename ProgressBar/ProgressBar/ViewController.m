//
//  ViewController.m
//  ProgressBar
//
//  Created by ShaoFeng on 2016/11/30.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//  //http://www.cnblogs.com/wendingding/p/3801036.html
//  //http://www.jianshu.com/p/02c341c748f9
//  //http://www.jianshu.com/p/734b34e82135

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.view.center.x - 10, self.view.center.y - 10) radius:20 startAngle:-0.5 * M_PI endAngle:1.5 * M_PI clockwise:YES];  //设置起点/终点/半径/中心
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor; //空心区域显示的颜色
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;  //进度圈的颜色
    [self.view.layer addSublayer:shapeLayer];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3.0f;
    pathAnimation.speed = 2.0f;       //加载速度
    //pathAnimation.repeatCount = 5;  //重复的次数
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]; //先快后慢,先慢后快...
    pathAnimation.fromValue = [NSNumber numberWithFloat:0]; //起始位置
    pathAnimation.toValue = [NSNumber numberWithFloat:1];   //终点位置
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}


@end
