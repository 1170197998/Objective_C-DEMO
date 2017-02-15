//
//  ScanCodeController.m
//  AlipayScanQRCode
//
//  Created by ShaoFeng on 2017/2/15.
//  Copyright © 2017年 ShaoFeng. All rights reserved.
//

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kBorderW 140
#define kMargin 35

#import "ScanCodeController.h"
#import "UIView+extension.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanCodeController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, strong) UIView *scanView;
@property (nonatomic, strong) UIImageView *scanImageView;
@end

@implementation ScanCodeController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resumeAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds=YES;
    [self setupMaskView];
    [self setupTipTitleView];
    [self setupscanViewView];
    [self beginScanning];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupTipTitleView{
    
    UIView *mask=[[UIView alloc] initWithFrame:CGRectMake(0, _maskView.y+_maskView.height, self.view.width, kBorderW+200)];
    mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:mask];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height * 0.9 - (SCREEN_HEIGHT / 7), self.view.bounds.size.width, (SCREEN_HEIGHT / 7))];
    tipLabel.text = @"将二维码放入框内，即可扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
}

- (void)setupMaskView
{
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6].CGColor;
    mask.layer.borderWidth = kBorderW;
    mask.bounds = CGRectMake(0, 0, self.view.width + kBorderW + kMargin * 2, self.view.width +kBorderW +kMargin * 2);
    mask.center = CGPointMake(self.view.width * 0.5, self.view.height * 2 );
    mask.y = 0;
    [self.view addSubview:mask];
}

- (void)setupscanViewView
{
    CGFloat scanViewH = self.view.width - kMargin * 2;
    CGFloat scanViewW = self.view.width - kMargin * 2;
    _scanView = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW, scanViewW, scanViewH)];
    _scanView.clipsToBounds = YES;
    [self.view addSubview:_scanView];
    
    _scanImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sweep_bg_line.png"]];
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"sweep_kuangupperleft.png"] forState:UIControlStateNormal];
    [_scanView addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanViewW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"sweep_kuangupperright.png"] forState:UIControlStateNormal];
    [_scanView addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanViewH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"sweep_kuangdownleft.png"] forState:UIControlStateNormal];
    [_scanView addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"sweep_kuangdownright.png"] forState:UIControlStateNormal];
    [_scanView addSubview:bottomRight];
}

- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    output.rectOfInterest = CGRectMake(0.1, 0, 0.9, 1);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        NSURL *url = [NSURL URLWithString: metadataObject.stringValue];
        if ([[UIApplication sharedApplication] canOpenURL: url]) {
            [self.navigationController popViewControllerAnimated:YES];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            UIAlertController *alertControlelr = [UIAlertController alertControllerWithTitle:@"扫描结果" message:metadataObject.stringValue preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"再次扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [_session startRunning];
            }];
            [alertControlelr addAction:action1];
            [alertControlelr addAction:action2];
            [self presentViewController:alertControlelr animated:YES completion:nil];
        }
    }
}

//获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = (CGRectGetHeight(readerViewBounds) - CGRectGetHeight(rect)) / 2 / CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds) - CGRectGetWidth(rect)) / 2 / CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect) / CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect) / CGRectGetWidth(readerViewBounds);
    return CGRectMake(x, y, width, height);
}

//恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanImageView.layer animationForKey:@"translationAnimation"];
    if(anim) {
        // 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanImageView.layer.timeOffset;
        // 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        // 把偏移时间清零
        [_scanImageView.layer setTimeOffset:0.0];
        // 设置图层的开始动画时间
        [_scanImageView.layer setBeginTime:beginTime];
        [_scanImageView.layer setSpeed:1.8];
        
    } else {
        CGFloat scanImageViewH = 241;
        CGFloat scanViewH = self.view.width - kMargin * 2;
        CGFloat scanImageViewW = _scanView.width;
        
        _scanImageView.frame = CGRectMake(0, -scanImageViewH, scanImageViewW, scanImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanViewH);
        scanNetAnimation.duration = 1.8;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanView addSubview:_scanImageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
