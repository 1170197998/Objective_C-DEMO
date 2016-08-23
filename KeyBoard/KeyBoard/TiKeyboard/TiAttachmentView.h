//
//  TiAttachmentView.h
//  TiKeyboardTest
//
//  Created by Eric on 15/4/30.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AttachmentSelectedStauts) {
    AttachmentSelectedStauts_Photo,
    AttachmentSelectedStauts_Video,
    AttachmentSelectedStauts_Sight,
    AttachmentSelectedStauts_VideoVoip,
    AttachmentSelectedStauts_MyFav,
    AttachmentSelectedStauts_Location,
    AttachmentSelectedStauts_FriendCard,
    AttachmentSelectedStauts_VoiceInput,
    AttachmentSelectedStauts_WXTalk
};

@protocol TiAttachmentViewDelegate <NSObject>

- (void)attachmentClicked:(AttachmentSelectedStauts)status;

@end

@interface TiAttachmentView : UIView <UIScrollViewDelegate>{
    UIImageView *_topLine;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@property(nonatomic,assign)id<TiAttachmentViewDelegate>delegate;

@end
