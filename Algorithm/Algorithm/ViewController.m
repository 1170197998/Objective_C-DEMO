//
//  ViewController.m
//  Algorithm
//
//  Created by ShaoFeng on 2016/12/20.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"
#import "Sort.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Sort *sort = [[Sort alloc] init];
    
//    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:@6,@5,@8,@1,@9,@8, nil];
    NSMutableArray *mArray = [NSMutableArray arrayWithObjects:@6,@5,@8,@1,@9,@8,@45,@89,@97,@156,@789,@-5,@84,@262,@-658,@256,@963, nil];
    
    NSLog(@"排序前:%@",mArray);
    
    //快速排序
    //[sort quickSort:mArray leftIndex:0 rightIndex:(int)mArray.count - 1];
    
    //冒泡排序
    //[sort bubbleSort:mArray];
    
    //选择排序
    //[sort selectSort:mArray];
    
    //直接插入排序
    //[sort insertSort:mArray];
    
    //二分插入排序
    //[sort binaryInsertSort:mArray];
    
    //希尔排序
    [sort shellSort:mArray];
    NSLog(@"排序后:%@",mArray);
}



@end
