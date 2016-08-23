//
//  RecordGestureRecognizer.h
//  TiKeyboardTest
//
//  Created by Eric-WekSoft on 15/5/25.
//  Copyright (c) 2015年 Zentertain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JFTouchDown)();
typedef void(^JFTouchMoveOutside)();
typedef void(^JFTouchMoveInside)();
typedef void(^JFTouchEnd)(BOOL inside);

@interface RecordGestureRecognizer : UIGestureRecognizer{
    BOOL _inside;
}

@property (nonatomic,copy) JFTouchDown touchDown;
@property (nonatomic,copy) JFTouchMoveOutside moveOutside;
@property (nonatomic,copy) JFTouchMoveInside moveInside;
@property (nonatomic,copy) JFTouchEnd touchEnd;

@end
