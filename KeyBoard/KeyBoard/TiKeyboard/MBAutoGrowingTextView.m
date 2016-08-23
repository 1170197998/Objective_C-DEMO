////
////  TINAutoGrowingTextView.m
////  TINUIKit
////
////  Created by Matej Balantic on 14/05/14.
////  Copyright (c) 2014 Matej Balantič. All rights reserved.
////
//
//#import "MBAutoGrowingTextView.h"
//#import "TiEmotion.h"
//#import "NSAttributedString+Emotion.h"
//@interface MBAutoGrowingTextView ()<UITextViewDelegate>
//@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
//@property (nonatomic, weak) NSLayoutConstraint *minHeightConstraint;
//@property (nonatomic, weak) NSLayoutConstraint *maxHeightConstraint;
//@property (nonatomic, strong) NSDictionary *defaultAttributes;
//@property BOOL editing;
//@end
//
//@implementation MBAutoGrowingTextView
//-(instancetype)init
//{
//    self = [super init];
//    
//    if (self) {
//        self.delegate = self;
//        self.layoutManager.allowsNonContiguousLayout = NO;
//        _defaultAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor colorWithRed:76/255. green:76/255. blue:76/255. alpha:1.]};
//        self.typingAttributes = _defaultAttributes;
//        self.linkTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:85/255. green:108/255. blue:133/255. alpha:1.]};
//        
//    }
//    
//    return self;
//}
//
//- (void)initialize
//{
//    [self associateConstraints];
//}
//
//-(BOOL)becomeFirstResponder
//{
//    self.spellCheckingType = UITextSpellCheckingTypeNo;
//    self.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.autocapitalizationType = UITextAutocorrectionTypeNo;
//    return [super becomeFirstResponder];
//}
//
//-(void)associateConstraints
//{
//    // iterate through all text view's constraints and identify
//    // height, max height and min height constraints.
//    
//    for (NSLayoutConstraint *constraint in self.constraints) {
//        if (constraint.firstAttribute == NSLayoutAttributeHeight) {
//            
//            if (constraint.relation == NSLayoutRelationEqual) {
//                self.heightConstraint = constraint;
//            }
//            
//            else if (constraint.relation == NSLayoutRelationLessThanOrEqual) {
//                self.maxHeightConstraint = constraint;
//            }
//            
//            else if (constraint.relation == NSLayoutRelationGreaterThanOrEqual) {
//                self.minHeightConstraint = constraint;
//            }
//        }
//    }
//    
//}
//
//- (void) layoutSubviews
//{
//    [super layoutSubviews];
//    
//    
//    NSAssert(self.heightConstraint != nil, @"Unable to find height auto-layout constraint. MBAutoGrowingTextView\
//             needs a Auto-layout environment to function. Make sure you are using Auto Layout and that UITextView is enclosed in\
//             a view with valid auto-layout constraints.");
//    
//    // calculate size needed for the text to be visible without scrolling
//    CGSize sizeThatFits = [self sizeThatFits:self.frame.size];
//    float newHeight = sizeThatFits.height;
//    // if there is any minimal height constraint set, make sure we consider that
//    if (self.maxHeightConstraint) {
//        newHeight = MIN(newHeight, self.maxHeightConstraint.constant);
//    }
//    
//    // if there is any maximal height constraint set, make sure we consider that
//    if (self.minHeightConstraint) {
//        newHeight = MAX(newHeight, self.minHeightConstraint.constant);
//    }
//    if(newHeight == self.heightConstraint.constant)
//    {
//        return;
//    }
//    if ([_growDelegate respondsToSelector:@selector(sizeWillChange:)])
//    {
//        [_growDelegate sizeWillChange:newHeight];
//    }
//    // update the height constraint
//    self.heightConstraint.constant = newHeight;
//    [self setNeedsUpdateConstraints];
//    [self updateConstraintsIfNeeded];
//    [UIView animateWithDuration:0.2f animations:^{
//        [self layoutIfNeeded];
//    }];
//}
//
//-(NSString*) text
//{
//    NSAttributedString * att = self.attributedText;
//    
//    NSMutableAttributedString * resutlAtt = [[NSMutableAttributedString alloc]initWithAttributedString:att];
//    
//    //枚举出所有的附件字符串
//    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//        //key-NSAttachment
//        //NSTextAttachment value类型
//        NSTextAttachment * textAtt = attrs[NSAttachmentAttributeName];//从字典中取得那一个图片
//        if (textAtt)
//        {
//            UIImage * image = textAtt.image;
//            [resutlAtt replaceCharactersInRange:range withString:[TiEmotion sharedTiEmotion].emotions[[[TiEmotion sharedTiEmotion].images indexOfObject:image]]];
//        }
//    }];
//    return resutlAtt.string;
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)atext {
//    _editing = YES;
//    if ([atext isEqualToString:@"\n"]) {
//        if ([_growDelegate respondsToSelector:@selector(shouldReturn)]) {
//            [_growDelegate performSelector:@selector(shouldReturn)];
//            return NO;
//        }
//    }
//    if ([atext isEqualToString:@"@"]) {
//        if ([_growDelegate respondsToSelector:@selector(shouldAt)])
//        {
//            if(range.location > 0)
//            {
//                NSAttributedString *sub = [self.attributedText attributedSubstringFromRange:NSMakeRange(range.location - 1, 1)];
//                NSString* pattern = @"[0-9a-zA-Z_]";
//                NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
//                NSArray* result = [regular matchesInString:[sub string] options:0 range:NSMakeRange(0, sub.length)];
//                if(result.count == 0)
//                {
//                    [_growDelegate performSelector:@selector(shouldAt)];
//                    return NO;
//                }
//            }
//            else
//            {
//                NSLog(@"4");
//                [_growDelegate performSelector:@selector(shouldAt)];
//                return NO;
//            }
//        }
//    }
//    self.typingAttributes = _defaultAttributes;
//    return YES;
//}
//
//-(void)textViewDidChange:(UITextView *)textView
//{
//    [self layoutSubviews];
//    if ([_growDelegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [_growDelegate performSelector:@selector(textViewDidChange:) withObject:self];
//    }
//    _editing = NO;
//}
//
//
//-(void)textViewDidChangeSelection:(UITextView *)textView
//{
//    if(self.selectedRange.location == textView.attributedText.length || _editing)
//    {
//        return;
//    }
//    _editing = YES;
//    __block NSMutableArray *ranges = [[NSMutableArray alloc] init];
//    [self.attributedText enumerateAttribute:NSLinkAttributeName
//                                    inRange:NSMakeRange(0, [self.attributedText length])
//                                    options:0
//                                 usingBlock:^(id value, NSRange range, BOOL *stop) {
//                                     if (value)
//                                         [ranges addObject:[NSValue valueWithRange:range]];
//                                 }];
//    NSValue* start;
//    NSValue* stop;
//    for (NSValue* value in ranges) {
//        if(!start)
//        {
//            if(value.rangeValue.location <=  self.selectedRange.location && (value.rangeValue.location + value.rangeValue.length >= self.selectedRange.location))
//            {
//                start = value;
//            }
//        }
//        NSUInteger endPoint = self.selectedRange.location + self.selectedRange.length;
//        if (endPoint >= value.rangeValue.location && endPoint <= value.rangeValue.location + value.rangeValue.length)
//        {
//            stop = value;
//        }
//    }
//    if(!start)
//    {
//        start = [NSValue valueWithRange:self.selectedRange];
//    }
//    if(!stop)
//    {
//        stop = [NSValue valueWithRange:self.selectedRange];
//    }
//    self.selectedRange = NSMakeRange(start.rangeValue.location, stop.rangeValue.location + stop.rangeValue.length - start.rangeValue.location);
//    self.typingAttributes = _defaultAttributes;
//    _editing = NO;
//}
//
//-(void)deleteBackward
//{
//    _editing = YES;
//    if(self.selectedRange.length == 0 && self.selectedRange.location > 1)
//    {
//        NSAttributedString* sub = [self.attributedText attributedSubstringFromRange:NSMakeRange(self.selectedRange.location - 1, 1)];
//        if([sub.string isEqualToString:@" "])
//        {
//            BOOL hitFlag = NO;
//            NSRange range;
//            NSString* attr = [self.attributedText attribute:NSLinkAttributeName atIndex:self.selectedRange.location - 2 effectiveRange:&range];
//            while(attr)
//            {
//                hitFlag = YES;
//                if(range.location == 0)
//                    break;
//                attr = [self.attributedText attribute:NSLinkAttributeName atIndex:range.location - 1 effectiveRange:&range];
//            }
//            if(hitFlag)
//            {
//                NSUInteger index = range.location + range.length;
//                if(range.location == 0 && attr)
//                {
//                    index = 0;
//                }
//                self.selectedRange = NSMakeRange(index, self.selectedRange.location - index);
//            }
//        }
//    }
//    [super deleteBackward];
//    self.typingAttributes = _defaultAttributes;
//    _editing = NO;
//}
//
//-(void)paste:(id)sender
//{
//    NSUInteger location  = self.selectedRange.location;
//    UIPasteboard *board = [UIPasteboard generalPasteboard];
//    NSString *text = board.string;
//    NSAttributedString *newStr = [NSAttributedString emotionAttributedStringFrom:text attributes:_defaultAttributes];
//    NSMutableAttributedString *current = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
//    [current beginEditing];
//    [current replaceCharactersInRange:self.selectedRange withAttributedString:newStr];
//    [current endEditing];
//    NSUInteger length = location + [newStr length];
//    self.attributedText = current;
//    if ([_growDelegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [_growDelegate performSelector:@selector(textViewDidChange:) withObject:self];
//    }
//    self.typingAttributes = _defaultAttributes;
//    self.selectedRange = NSMakeRange(length,0);
//    self.scrollsToTop=YES;
//    [self layoutSubviews];
//    [self scrollRangeToVisible:self.selectedRange];
//}
//
//-(void)copy:(id)sender
//{
//    UIPasteboard *board = [UIPasteboard generalPasteboard];
//    [board setString:self.text];
//}
//
//-(void)setText:(NSString *)text
//{
//    if(!text)
//    {
//        super.text = nil;
//        return;
//    }
//    NSAttributedString *newStr = [NSAttributedString emotionAttributedStringFrom:text attributes:_defaultAttributes];
//    self.attributedText = newStr;
//    if ([_growDelegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [_growDelegate performSelector:@selector(textViewDidChange:) withObject:self];
//    }
//    self.typingAttributes = _defaultAttributes;
//    self.selectedRange = NSMakeRange(self.attributedText.length,0);
//    self.scrollsToTop=YES;
//    [self layoutSubviews];
//    [self scrollRangeToVisible:self.selectedRange];
//}
//
//- (void)addText:(NSString *)text{
//    NSMutableAttributedString *current = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
//    [current beginEditing];
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:text attributes:_defaultAttributes];
//    [current replaceCharactersInRange:self.selectedRange withAttributedString:str];
//    [current endEditing];
//    _editing = YES;
//    self.attributedText = current;
//    if ([_growDelegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [_growDelegate performSelector:@selector(textViewDidChange:) withObject:self];
//    }
//    self.typingAttributes = _defaultAttributes;
//    self.selectedRange = NSMakeRange(self.selectedRange.location+str.length, 0) ;
//    self.scrollsToTop=YES;
//    [self layoutSubviews];
//    [self scrollRangeToVisible:self.selectedRange];
//    _editing = NO;
//}
//
//-(void)addEmotion:(NSString *)text
//{
//    
//    NSTextAttachment *attachment = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
//    attachment.image = [TiEmotion sharedTiEmotion].images[[[TiEmotion sharedTiEmotion].emotions indexOfObject:text]];
//    attachment.bounds = CGRectMake( 0 , -6.5, 24, 24);
//    NSParameterAssert(attachment);
//    NSMutableAttributedString *current = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
//    NSAttributedString *imageAttributeString = [NSAttributedString attributedStringWithAttachment:attachment];
//    [current replaceCharactersInRange:self.selectedRange withAttributedString:imageAttributeString];
//    _editing = YES;
//    self.attributedText = current;
//    if ([_growDelegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [_growDelegate performSelector:@selector(textViewDidChange:) withObject:self];
//    }
//    self.typingAttributes = _defaultAttributes;
//    self.selectedRange = NSMakeRange(self.selectedRange.location+imageAttributeString.length, 0) ;
//    self.scrollsToTop=YES;
//    [self layoutSubviews];
//    [self scrollRangeToVisible:self.selectedRange];
//    _editing = NO;
//}
//
//- (void)addLink:(NSString *)text value:(NSString*)value
//{
//    NSMutableAttributedString *current = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
//    [current beginEditing];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
//    [str addAttribute:NSLinkAttributeName value:value range:NSMakeRange(0, text.length - 1)];
//    [str addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:210/255. green:210/255. blue:210/255. alpha:1.] range:NSMakeRange(0, text.length - 1)];
//    [current replaceCharactersInRange:self.selectedRange withAttributedString:str];
//    [current endEditing];
//    _editing = YES;
//    self.attributedText = current;
//    if ([_growDelegate respondsToSelector:@selector(textViewDidChange:)]) {
//        [_growDelegate performSelector:@selector(textViewDidChange:) withObject:self];
//    }
//    self.typingAttributes = _defaultAttributes;
//    self.selectedRange = NSMakeRange(self.selectedRange.location+str.length, 0) ;
//    self.scrollsToTop=YES;
//    [self layoutSubviews];
//    [self scrollRangeToVisible:self.selectedRange];
//    _editing = NO;
//}
//
//- (NSArray<NSString*>*) atList
//{
//    NSMutableDictionary* atDic = [NSMutableDictionary new];
//    NSAttributedString * att = self.attributedText;
//    
//    //枚举出所有的附件字符串
//    [att enumerateAttributesInRange:NSMakeRange(0, att.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
//        //key-NSAttachment
//        //NSTextAttachment value类型
//        NSString * textAtt = attrs[NSLinkAttributeName];//从字典中取得那一个图片
//        if (textAtt)
//        {
//            [atDic setObject:[NSNull null] forKey:textAtt];
//        }
//    }];
//    return [atDic allKeys];
//}
//
//- (void)removePreChar
//{
//    [self deleteBackward];
//}
//@end