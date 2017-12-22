//
//  RenderView.h
//  Statements RenderView
//
//  Created by Moncter8 on 13-5-30.
//  Copyright (c) 2013年 Moncter8. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RenderView;
@protocol RenderViewDataSource <NSObject>
@required
- (NSUInteger)numberOfSlicesInPieChart:(RenderView *)pieChart;
- (CGFloat)pieChart:(RenderView *)pieChart valueForSliceAtIndex:(NSUInteger)index;
@optional
- (UIColor *)pieChart:(RenderView *)pieChart colorForSliceAtIndex:(NSUInteger)index;
@end

@protocol RenderViewtDelegate <NSObject>
@optional
- (void)pieChart:(RenderView *)pieChart willSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(RenderView *)pieChart didSelectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(RenderView *)pieChart willDeselectSliceAtIndex:(NSUInteger)index;
- (void)pieChart:(RenderView *)pieChart didDeselectSliceAtIndex:(NSUInteger)index;
- (void)animateFinish:(RenderView *)pieChart;
@end

@interface RenderView : UIView
@property(nonatomic, weak) id<RenderViewDataSource> dataSource;
@property(nonatomic, weak) id<RenderViewtDelegate> delegate;
@property(nonatomic, assign) CGFloat startPieAngle;
@property(nonatomic, assign) CGFloat animationSpeed;
@property(nonatomic, assign) CGPoint pieCenter;
@property(nonatomic, assign) CGFloat pieRadius;
@property(nonatomic, assign) BOOL    showLabel;
@property(nonatomic, strong) UIFont  *labelFont;
@property(nonatomic, assign) CGFloat labelRadius;
@property(nonatomic, assign) CGFloat selectedSliceStroke;
@property(nonatomic, assign) CGFloat selectedSliceOffsetRadius;
@property(nonatomic, assign) BOOL    showPercentage;
- (id)initWithFrame:(CGRect)frame Center:(CGPoint)center Radius:(CGFloat)radius;
- (void)reloadData;
- (void)setPieBackgroundColor:(UIColor *)color;
- (void)pieSelected:(NSInteger)selIndex;
@end;
