//
//  ViewController.m
//  ReadHealthSteps
//
//  Created by ShaoFeng on 2017/2/8.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#import "ViewController.h"
#import <HealthKit/HealthKit.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showStepsLabel;
@property (nonatomic,strong)HKHealthStore *healthStore;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.showStepsLabel.layer.cornerRadius = self.showStepsLabel.frame.size.width/2;
    self.showStepsLabel.layer.borderColor = [UIColor redColor].CGColor;
    self.showStepsLabel.layer.borderWidth = 5;
    self.showStepsLabel.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readSteps];
}

- (IBAction)clickReadSteps:(id)sender
{
    [self readSteps];
}

- (void)readSteps
{
    //查看healthKit在设备上是否可用，iPad上不支持HealthKit
    if (![HKHealthStore isHealthDataAvailable]) {
        self.showStepsLabel.text = @"该设备不支持HealthKit";
    }
    self.healthStore = [[HKHealthStore alloc] init];
    //设置需要获取的类型为步数
    HKObjectType *type = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSet *set = [NSSet setWithObjects:type, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:set completion:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //权限获取成功,计算步数
            [self readStepsCount];
        } else {
            self.showStepsLabel.text = @"权限获取失败";
        }
    }];
}

//计算步数
- (void)readStepsCount
{
    //查询采样信息
    HKSampleType *sameType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    NSSortDescriptor *start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calender components:unitFlags fromDate:now];
    int hour = (int)[dateComponent hour];
    int minute = (int)[dateComponent minute];
    int second = (int)[dateComponent second];
    //当前时刻
    NSLog(@"当前时间为:%d时--%d分--%d秒",hour,minute,second);
    //返回当前时间hour * 3600 + minute * 60 + second之前的时间,即为今天凌晨0点
    NSDate *nowDay = [NSDate dateWithTimeIntervalSinceNow: - (hour * 3600 + minute * 60 + second)];
    //时间结果与想象中不同是因为它显示的是0区
    NSLog(@"今天%@",nowDay);
    //一天是60分钟 * 60秒 * 24小时 = 86400秒
    NSDate *nextDay = [NSDate dateWithTimeIntervalSinceNow: - (hour * 3600 + minute * 60 + second) + 86400];
    NSLog(@"明天%@",nextDay);
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:nowDay endDate:nextDay options:(HKQueryOptionNone)];
    NSLog(@"%@",predicate);
    
    //predicate计算的是今天凌晨0点到晚上24点(明天凌晨0点)时间段内的步数
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sameType predicate:predicate limit:0 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        int allStepCount = 0;
        NSLog(@"%@--%ld",results,results.count);
        //循环累加计算各个时间段的步数
        for (int i = 0; i < results.count; i ++) {
            //把结果转换为字符串类型
            HKQuantitySample *result = results[i];
            HKQuantity *quantity = result.quantity;
            NSMutableString *stepCount = (NSMutableString *)quantity;
            NSString *stepStr =[NSString stringWithFormat:@"%@",stepCount];
            //获取51 count此类字符串前面的数字
            NSString *str = [stepStr componentsSeparatedByString:@" "][0];
            int stepNum = [str intValue];
            NSLog(@"%d",stepNum);
            //把一天中所有时间段中的步数加到一起
            allStepCount = allStepCount + stepNum;
        }
        //查询要放在多线程中进行，如果要对UI进行刷新，要回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.showStepsLabel.text = [NSString stringWithFormat:@"%d",allStepCount];
        }];
    }];
    //执行查询
    [self.healthStore executeQuery:query];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
