//
//  EmojiButtonView.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/18.
//  Copyright © 2016年 Cocav. All rights reserved.
//
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

#import "EmojiButtonView.h"
#import "CollectionViewFlowLayout.h"
#import "EmojiCollectionViewCell.h"

@interface EmojiButtonView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UIView *emojiFooterView;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIButton *sendButton;
@property (nonatomic,strong)UIButton *emojiButotn;
@property (nonatomic,strong)CollectionViewFlowLayout *layout;
@property (nonatomic,strong)NSMutableArray *defaultEmoticons;
@end

@implementation EmojiButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _defaultEmoticons = [NSMutableArray array];

        for (int i=0x1F600; i<=0x1F64F; i++) {
            if (i < 0x1F641 || i > 0x1F644) {
                int sym = EMOJI_CODE_TO_SYMBOL(i);
                NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
                [_defaultEmoticons addObject:emoT];
            }
        }
        
        self.backgroundColor = [UIColor cyanColor];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    self.emojiFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 40)];
    self.emojiFooterView.backgroundColor = [UIColor purpleColor];
    [self addSubview:self.emojiFooterView];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 4, 0, SCREEN_WIDTH / 5, 40)];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.emojiFooterView addSubview:self.sendButton];
    
    self.emojiButotn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 5, 40)];
    [self.emojiButotn setImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_press"] forState:UIControlStateNormal];
    [self.emojiFooterView addSubview:self.emojiButotn];
    self.layout = [[CollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor cyanColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.defaultEmoticons.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmojiCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:(random() % 255) / 255.0 green:(random() % 255) / 255.0 blue:(random() % 255) / 255.0 alpha:1];
    cell.string = self.defaultEmoticons[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.defaultEmoticons[indexPath.row];
    NSLog(@"%@",str);
    
    if ([_delegate respondsToSelector:@selector(emojiButtonView:text:)]) {
        [_delegate emojiButtonView:self text:str];
    }
}

- (void)clickSenderButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(emojiButtonView:sendButtonClick:)]) {
        [_delegate emojiButtonView:self sendButtonClick:sender];
    }
}

@end


