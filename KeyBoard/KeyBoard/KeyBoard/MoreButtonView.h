//
//  MoreButtonScrollView.h
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreButtonView;
typedef enum {
    MoreButtonViewButtonTypeImages,
    MoreButtonViewButtonTypeCamera,
    MoreButtonViewButtonTypeFile,
    MoreButtonViewButtonTypeContact,
    MoreButtonViewButtonTypeLocation,
    MoreButtonViewButtonTypeSeal,
    MoreButtonViewButtonTypeEmail,
} MoreButtonViewButtonType;

@protocol MoreButtonViewDelegate <NSObject>
- (void)moreButtonView:(MoreButtonView *)moreButtonView didClickButton:(MoreButtonViewButtonType )buttonType;
@end

@interface MoreButtonView : UIView
@property (nonatomic,strong) id<MoreButtonViewDelegate>delegate;
@end
