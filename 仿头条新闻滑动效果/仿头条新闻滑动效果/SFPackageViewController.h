//
//  SFPackageViewController.h
//  仿头条新闻滑动效果
//
//  Created by Cocav on 16/3/20.
//  Copyright © 2016年 cocav. All rights reserved.
//
//get the width of the screen
#define SCR_W [UIScreen mainScreen].bounds.size.width

//get the width of the screen
#define SCR_H [UIScreen mainScreen].bounds.size.height

//custom RGB color
#define RGB(__r,__g,__b) [UIColor colorWithRed:(__r) / 255.0 green:(__g) / 255.0 blue:(__b) / 255.0 alpha:1]

#define topButtonWidth 100


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SFPackageViewController : NSObject

/**
 *  根据点击的view,设置合适的移动距离
 *
 *  @param currentClickview 当前点击的空间
 *  @param moveScrollView   整个ScrollView
 */
+ (void)setMoveScrollViewContentOffsetWithCurrentClickView:(UIView *)currentClickview andMoveScrollView:(UIScrollView *)moveScrollView;

@end
