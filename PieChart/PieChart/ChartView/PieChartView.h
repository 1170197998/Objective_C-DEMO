//
//  PieChartView.h
//  Statements
//
//  Created by Moncter8 on 13-5-30.
//  Copyright (c) 2013年 Moncter8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RotatedView.h"
@class PieChartView;
@protocol PieChartDelegate <NSObject>
@optional
- (void)selectedFinish:(PieChartView *)pieChartView index:(NSInteger)index percent:(float)per;
- (void)onCenterClick:(PieChartView *)PieChartView;
@end

@interface PieChartView : UIView <RotatedViewDelegate>
@property(nonatomic, weak) id<PieChartDelegate> delegate;
- (id)initWithFrame:(CGRect)frame withValue:(NSMutableArray *)valueArr withColor:(NSMutableArray *)colorArr;
- (void)reloadChart;
- (void)setAmountText:(NSString *)text;
- (void)setTitleText:(NSString *)text;
@end
