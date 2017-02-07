//
//  DKTextField.m
//  DKTextField
//
//  Created by ShaoFeng on 16/6/16.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "SFTextField.h"

@interface SFTextField ()
@property (nonatomic,copy) NSString *password;
@property (nonatomic,weak) id beginEditingObserver;
@property (nonatomic,weak) id endEditingObserver;
@end

@implementation SFTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.password = @"";
    __weak SFTextField *weakSelf = self;
    
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
            weakSelf.text = @"";
            [weakSelf insertText:weakSelf.password];
        }
    }];
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        if (weakSelf == note.object) {
            weakSelf.password = weakSelf.text;
        }
    }];
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    BOOL isFirstResponder = self.isFirstResponder;
    [self resignFirstResponder];
    [super setSecureTextEntry:secureTextEntry];
    if (isFirstResponder) {
        [self becomeFirstResponder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];
}

@end
