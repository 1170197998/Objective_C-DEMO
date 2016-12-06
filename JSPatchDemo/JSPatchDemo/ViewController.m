//
//  ViewController.m
//  JSPatchDemo
//
//  Created by ShaoFeng on 2016/12/6.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"
#import "JPEngine.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [JPEngine startEngine];
//    NSString *path = @"/Users/cocav/Desktop/test.js";
    NSString *path =[[NSBundle mainBundle] pathForResource:@"test" ofType:@"js"];
    NSString *script = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [JPEngine evaluateScript:script];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightButtonItemClick)];
}

- (void)rightButtonItemClick
{
    
}


@end
