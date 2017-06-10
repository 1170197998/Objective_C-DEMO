//
//  ViewController.m
//  Autograph
//
//  Created by ShaoFeng on 2017/6/9.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"
#import "SignViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,assign)BOOL isMoving;
@property (nonatomic,assign)CGPoint lastPoint;
@property (nonatomic,strong)NSMutableArray *xPoints;
@property (nonatomic,strong)NSMutableArray *yPoints;
@end

@implementation ViewController

- (NSMutableArray *)xPoints
{
    if (!_xPoints) {
        _xPoints = [NSMutableArray array];
    }
    return _xPoints;
}

- (NSMutableArray *)yPoints
{
    if (!_yPoints) {
        _yPoints = [NSMutableArray array];
    }
    return _yPoints;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isMoving = false;
    UITouch *touch = touches.anyObject;
    self.lastPoint = [touch locationInView:self.imageView];
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.isMoving = true;
    UITouch *touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self.imageView];
    UIGraphicsBeginImageContext(self.imageView.frame.size);
    [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound); //线条短点形状
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 3.0); //线宽
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0); //颜色
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.lastPoint = currentPoint;
    [self.xPoints addObject:[NSNumber numberWithFloat:self.lastPoint.x]];
    [self.yPoints addObject:[NSNumber numberWithFloat:self.lastPoint.y]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(!self.isMoving) {
        UIGraphicsBeginImageContext(self.imageView.frame.size);
        [self.imageView.image drawInRect:CGRectMake(0, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), 3.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
}

- (IBAction)cancel:(id)sender {
    self.imageView.image = nil;
}

- (IBAction)push:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignViewController *vc = [story instantiateViewControllerWithIdentifier:@"sign"];
    [self.navigationController pushViewController:vc animated:true];
    vc.image = self.imageView.image;
}

@end
