//
//  Sort.m
//  Algorithm
//
//  Created by ShaoFeng on 2016/12/20.
//  Copyright © 2016年 ShaoFeng. All rights reserved.
//

#import "Sort.h"

@implementation Sort

//快速排序
- (void)quickSort:(NSMutableArray *)mArray leftIndex:(int )left rightIndex:(int )right
{
    if (left < right) {
        int temp = [self getMiddleIndex:mArray leftIndex:left rightIndex:right];
        [self quickSort:mArray leftIndex:left rightIndex:temp - 1];
        [self quickSort:mArray leftIndex:temp + 1 rightIndex:right];
    }
}

- (int )getMiddleIndex:(NSMutableArray *)mArray leftIndex:(int )left rightIndex:(int )right
{
    int tempValue = [mArray[left] intValue];
    while (left < right) {
        while ((left < right) && (tempValue <= [mArray[right] intValue])) {
            right --;
        }
        if (left < right) {
            mArray[left] = mArray[right];
        }
        while (left < right && ([mArray[left] intValue] <= tempValue)) {
            left ++;
        }
        if (left < right) {
            mArray[right] = mArray[left];
        }
    }
    mArray[left] = [NSNumber numberWithInt:tempValue];
    return left;
}

//冒泡排序
- (void)bubbleSort:(NSMutableArray *)mArray
{
    for (int i = 0; i < mArray.count - 1; i ++) {
        for (int j = 0; j < mArray.count - i - 1; j ++) {
            if ([mArray[j] intValue] > [mArray[j + 1] intValue]) {
                [mArray exchangeObjectAtIndex:j withObjectAtIndex:j + 1];
            }
        }
    }
}

//选择排序
- (void)selectSort:(NSMutableArray *)mArray
{
    for (int i = 0; i < mArray.count; i ++) {
        int minIndex = i;
        for (int j = i + 1; j < mArray.count; j ++) {
            if ([mArray[minIndex] intValue] > [mArray[j] intValue]) {
                minIndex = j;
            }
        }
        if(minIndex != i) {
            //如果不是无序区的最小值位置不是默认的第一个数据，则交换。
            [mArray exchangeObjectAtIndex:i withObjectAtIndex:minIndex];
        }
    }
}

//直接插入排序
- (void)insertSort:(NSMutableArray*)array
{
    for (int i = 0;i < [array count] - 1;i ++) {
        if([[array objectAtIndex:i + 1]intValue] < [[array objectAtIndex:i] intValue]) {
            NSNumber *temp=[array objectAtIndex:i+1];
            for (int j = i + 1; j > 0 && [[array objectAtIndex:j - 1] intValue] > [temp intValue]; j --){
                [array exchangeObjectAtIndex:j - 1 withObjectAtIndex:j];
            }
        }
    }
}

//二分插入排序
- (void)binaryInsertSort:(NSMutableArray *)mArray
{
    //索引从1开始 默认让出第一元素为默认有序表 从第二个元素开始比较
    for(int i = 1 ; i < [mArray count] ; i++){
        //二分查找
        int temp= [[mArray objectAtIndex:i] intValue];
        int left = 0;
        int right = i - 1;
        while (left <= right) {
            int middle = (left + right)/2;
            if(temp < [[mArray objectAtIndex:middle] intValue]){
                right = middle - 1;
            } else {
                left = middle + 1;
            }
        }
        //排序
        for(int j = i ; j > left; j --){
            [mArray replaceObjectAtIndex:j withObject:[mArray objectAtIndex:j - 1]];
        }
        [mArray replaceObjectAtIndex:left withObject:[NSNumber numberWithInt:temp]];
    }
}

//希尔排序
-(void)shellSort:(NSMutableArray *)mArray
{
    int gap = (int)[mArray count] / 2;
    while (gap >= 1) {
        for(int i = gap ; i < [mArray count]; i ++){
            int temp = [[mArray objectAtIndex:i] intValue];
            int j = i;
            while (j >= gap && temp < [[mArray objectAtIndex:(j - gap)] intValue]) {
                [mArray replaceObjectAtIndex:j withObject:[mArray objectAtIndex:j-gap]];
                j -= gap;
            }
            [mArray replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:temp]];
        }
        gap = gap / 2;
    }
}

@end
