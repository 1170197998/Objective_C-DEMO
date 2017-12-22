//
//  ViewController.m
//  PieChart
//
//  Created by ShaoFeng on 2017/12/22.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//
#define PIE_HEIGHT 280
#import "ViewController.h"
#import "PieChartView.h"
@interface ViewController ()<PieChartDelegate>
@property (nonatomic,strong)NSMutableArray *mArrayValue;
@property (nonatomic,strong)NSMutableArray *mArrayColor;
@property (nonatomic,strong)NSMutableArray *mArrayValue2;
@property (nonatomic,strong)NSMutableArray *mArrayColor2;
@property (nonatomic,strong)PieChartView *pieChartView;
@property (nonatomic,strong)UIView *viewContainer;
@property (nonatomic,assign)BOOL inOut;
@property (nonatomic,strong)UILabel *labelData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inOut = YES;
    
    self.mArrayValue = [[NSMutableArray alloc] initWithObjects:@12,@3,@2,@3,@3,@4, nil];
    self.mArrayValue2 = [[NSMutableArray alloc] initWithObjects:@3,@2,@2, nil];
    self.mArrayColor = [[NSMutableArray alloc] initWithObjects:[UIColor redColor],[UIColor purpleColor], [UIColor yellowColor],[UIColor magentaColor],[UIColor orangeColor], [UIColor brownColor], nil];
    self.mArrayColor2 = [[NSMutableArray alloc] initWithObjects:[UIColor redColor],[UIColor purpleColor], [UIColor yellowColor], nil];
    
    //add shadow img
    CGRect pieFrame = CGRectMake((self.view.frame.size.width - PIE_HEIGHT) / 2, 0, PIE_HEIGHT, PIE_HEIGHT);
    
    UIImage *shadowImg = [UIImage imageNamed:@"shadow.png"];
    UIImageView *shadowImgView = [[UIImageView alloc]initWithImage:shadowImg];
    shadowImgView.frame = CGRectMake(0, pieFrame.origin.y + PIE_HEIGHT*0.92, shadowImg.size.width/2, shadowImg.size.height/2);
    [self.view addSubview:shadowImgView];
    
    
    self.viewContainer = [[UIView alloc]initWithFrame:pieFrame];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.viewContainer.bounds withValue:self.mArrayValue withColor:self.mArrayColor];
    self.pieChartView.delegate = self;
    [self.viewContainer addSubview:self.pieChartView];
    [self.pieChartView setAmountText:@"-2456.0"];
    [self.view addSubview:self.viewContainer];
    
    
    //add selected view
    UIImageView *selView = [[UIImageView alloc]init];
    selView.image = [UIImage imageNamed:@"select.png"];
    selView.frame = CGRectMake((self.view.frame.size.width - selView.image.size.width/2)/2, self.viewContainer.frame.origin.y + self.viewContainer.frame.size.height, selView.image.size.width/2, selView.image.size.height/2);
    [self.view addSubview:selView];
    
    self.labelData = [[UILabel alloc]initWithFrame:CGRectMake(0, 24, selView.image.size.width/2, 21)];
    self.labelData.backgroundColor = [UIColor clearColor];
    self.labelData.textAlignment = NSTextAlignmentCenter;
    self.labelData.font = [UIFont systemFontOfSize:17];
    self.labelData.textColor = [UIColor whiteColor];
    [selView addSubview:self.labelData];
    [self.pieChartView setTitleText:@"支出总计"];
    self.title = @"对账单";
}

- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per
{
    self.labelData.text = [NSString stringWithFormat:@"%2.2f%@",per*100,@"%"];
}

- (void)onCenterClick:(PieChartView *)pieChartView
{
    self.inOut = !self.inOut;
    self.pieChartView.delegate = nil;
    [self.pieChartView removeFromSuperview];
    self.pieChartView = [[PieChartView alloc]initWithFrame:self.viewContainer.bounds withValue:self.inOut?self.mArrayValue:self.mArrayValue2 withColor:self.inOut?self.mArrayColor:self.mArrayColor2];
    self.pieChartView.delegate = self;
    [self.viewContainer addSubview:self.pieChartView];
    [self.pieChartView reloadChart];
    
    if (self.inOut) {
        [self.pieChartView setTitleText:@"支出总计"];
        [self.pieChartView setAmountText:@"-2456.0"];
        
    }else{
        [self.pieChartView setTitleText:@"收入总计"];
        [self.pieChartView setAmountText:@"+567.23"];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.pieChartView reloadChart];
}

@end
