//
//  TINAutoGrowingTextView.h
//  TINUIKit
//
//  Created by Matej Balantic on 14/05/14.
//  Copyright (c) 2014 Matej Balantič. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * An auto-layout based light-weight UITextView subclass which automatically grows and shrinks
 based on the size of user input and can be constrained by maximal and minimal height - all without
 a single line of code.
 
 Made primarely for use in Interface builder and only works with Auto layout.
 
 Usage: subclass desired UITextView in IB and assign min-height and max-height constraints
 */
@protocol GrowingTextDelegate<NSObject>
-(void)sizeWillChange:(CGFloat)newHeight;
@optional
-(void)shouldReturn;
-(void)shouldAt;
-(void)textViewDidChange:(UITextView *)textView;
@end
@interface MBAutoGrowingTextView : UITextView
@property(nonatomic,weak)id<GrowingTextDelegate> growDelegate;
- (void)initialize;
- (void)addText:(NSString *)text;
- (void)addEmotion:(NSString *)text;
- (void)addLink:(NSString *)text value:(NSString*)value;
- (void)removePreChar;
- (NSArray<NSString*>*) atList;
@end