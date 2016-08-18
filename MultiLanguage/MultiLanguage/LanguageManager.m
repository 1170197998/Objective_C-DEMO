//
//  LanguageManager.m
//  MultiLanguage
//
//  Created by ShaoFeng on 16/8/9.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "LanguageManager.h"

@interface LanguageManager ()
{
    NSBundle *_languageBundle;
}

@end

@implementation LanguageManager

+(LanguageManager *)shareInstance
{
    static LanguageManager *languageManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        languageManager = [[LanguageManager alloc] init];
    });
    return languageManager;
}

- (void)initUserLanguage
{
    NSString *userLanguage = [[NSUserDefaults standardUserDefaults] valueForKey: @"userLanguage"];
    if (!userLanguage) {
        NSString* currentLanguage = [[[NSUserDefaults standardUserDefaults] objectForKey: @"AppleLanguages"] objectAtIndex:0];
        // 获得当前iPhone使用的语言
        userLanguage = currentLanguage;
        [self saveDefineUserLanguage:userLanguage];
    }
    //获取文件路径
    NSString *languagePath = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj"];
    _languageBundle = [NSBundle bundleWithPath:languagePath];//生成bundle
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]) {
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
        }
    }
    
    
}

-(void)saveDefineUserLanguage:(NSString *)userLanguage
{
    if (!userLanguage) {
        return;
    }
    
    if (userLanguage == _currentLanguage) {
        return;
    }
    _currentLanguage = userLanguage;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:userLanguage ofType:@"lproj" ];
    _languageBundle = [NSBundle bundleWithPath:path];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:userLanguage forKey:@"userLanguage"];
    [def synchronize];
}


@end
