//
//  ViewController.m
//  MultiLanguage
//
//  Created by ShaoFeng on 16/8/4.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIButton *test1;
@property (strong, nonatomic) IBOutlet UIButton *test2;
@property (strong, nonatomic) IBOutlet UIButton *operatorButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:@"LanguageChanged" object:nil];
    
    [self.test1 setTitle:Localized(@"huawei") forState:UIControlStateNormal];
    [self.test2 setTitle:Localized(@"apple") forState:UIControlStateNormal];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LanguageChanged" object:nil];
}

- (IBAction)changeLanguage:(id)sender {
    
    //修改本地获取的语言文件-交替
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([language isEqualToString: @"en"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self languageChanged];
    
    //发出通知-语言改变
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LanguageChanged" object:nil];
}

- (void)languageChanged{

    UIStoryboard*sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = (UIViewController*)[sb instantiateViewControllerWithIdentifier:@"main"];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = vc;
}


@end
