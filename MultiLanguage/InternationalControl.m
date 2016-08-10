//
//  internationalControl.m
//  MultiLanguage
//
//  Created by ShaoFeng on 16/8/9.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "InternationalControl.h"

@implementation InternationalControl


//创建静态变量bundle，以及获取方法bundle（注：此处不要使用getBundle）。
static NSBundle *bundle = nil;
+(NSBundle *)bundle{
    return bundle;
}

//初始化方法： userLanguage储存在NSUserDefaults中，首次加载时要检测是否存在，如果不存在的话读AppleLanguages，并赋值给userLanguage。

+(void)initUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if(string.length == 0){
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        string = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize];//持久化，不加的话不会保存
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

//获得当前语言方法
+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

//设置语言方法
+(void)setUserlanguage:(NSString *)language{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

@end
