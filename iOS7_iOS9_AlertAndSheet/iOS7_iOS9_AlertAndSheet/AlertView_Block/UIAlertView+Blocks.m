//
//  UIAlertView+Blocks.h
//  MeetYou
//
//  Created by Cocav on 16/2/19.
//  Copyright © 2016年 Eason. All rights reserved.

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

static NSString *RI_BUTTON_ASS_KEY = @"cocav.com";

@implementation UIAlertView (Blocks)

#pragma mark - 初始化
-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage leftButtonItem:(SFButtonItem *)inLeftButtonItem rightButtonItems:(SFButtonItem *)inRightButtonItems, ... NS_REQUIRES_NIL_TERMINATION;
{
    if((self = [self initWithTitle:inTitle message:inMessage delegate:self cancelButtonTitle:inLeftButtonItem.label otherButtonTitles:nil]))
    {
        NSMutableArray *buttonsArray = [self buttonItems];
        
        SFButtonItem *eachItem;
        va_list argumentList;
        if (inRightButtonItems) {
            
            [buttonsArray addObject: inRightButtonItems];
            va_start(argumentList, inRightButtonItems);
            while((eachItem = va_arg(argumentList, SFButtonItem *))) {
                
                [buttonsArray addObject: eachItem];
            }
            va_end(argumentList);
        }
        
        for(SFButtonItem *item in buttonsArray) {
            
            [self addButtonWithTitle:item.label];
        }
        
        if(inLeftButtonItem) {
         
            [buttonsArray insertObject:inLeftButtonItem atIndex:0];
        }
        
        [self setDelegate:self];
    }
    return self;
}

- (NSInteger)addButtonItem:(SFButtonItem *)item
{
    NSInteger buttonIndex = [self addButtonWithTitle:item.label];
    [[self buttonItems] addObject:item];
    
    if (![self delegate]) {
        
        [self setDelegate:self];
    }
    
    return buttonIndex;
}

#pragma mark - 代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        
        NSArray *buttonsArray = objc_getAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY);
        SFButtonItem *item = [buttonsArray objectAtIndex:buttonIndex];
        if(item.action){
            item.action();
        }
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)buttonItems
{
    NSMutableArray *buttonItems = objc_getAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY);
    if (!buttonItems) {
        
        buttonItems = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)RI_BUTTON_ASS_KEY, buttonItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return buttonItems;
}

@end
