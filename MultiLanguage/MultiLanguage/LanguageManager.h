//
//  LanguageManager.h
//  MultiLanguage
//
//  Created by ShaoFeng on 16/8/9.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageManager : NSObject


@property (nonatomic,strong)NSString *currentLanguage;
@property (nonatomic,strong)NSBundle *languageBundle;

- (void *)initUserLanguage;
+(LanguageManager *)shareInstance;

//- (void)getCurrentLanguage;
//- (void)getAllLanguage;

@end
