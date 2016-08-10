//
//  internationalControl.h
//  MultiLanguage
//
//  Created by ShaoFeng on 16/8/9.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternationalControl : NSObject

+(NSBundle *)bundle;//获取当前资源文件
+(void)initUserLanguage;//初始化语言文件
+(NSString *)userLanguage;//获取应用当前语言
+(void)setUserlanguage:(NSString *)language;//设置当前语言


@end
