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
#import "UIView+Extension.h"

@interface EmojiButtonView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UIView *emojiFooterView;
@property (nonatomic,strong)UIScrollView *emojiFooterScrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
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
        
        for (NSInteger i = 0;i < _defaultEmoticons.count;i ++) {
            if (i == 20 || i == 41 || i == 62 || i == 83) {
                [_defaultEmoticons insertObject:deleteButtonId atIndex:i];
            }
        }
        if (self.defaultEmoticons.count % 21 != 0) {
            for (NSInteger i = self.defaultEmoticons.count; i < self.defaultEmoticons.count + 21; i ++) {
                [self.defaultEmoticons addObject:@""];
                if (self.defaultEmoticons.count % 21 == 0) {
                    break;
                }
            }
        }
        [self.defaultEmoticons replaceObjectAtIndex:self.defaultEmoticons.count - 1 withObject:deleteButtonId];
        self.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI
{
    self.emojiFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 40)];
    self.emojiFooterView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.emojiFooterView];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 4, 0, SCREEN_WIDTH / 5, 40)];
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    self.sendButton.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sendButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.sendButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.emojiFooterView addSubview:self.sendButton];
    
    self.emojiFooterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - (SCREEN_WIDTH / 5) - 1, self.emojiFooterView.height)];
    self.emojiFooterScrollView.showsHorizontalScrollIndicator = NO;
    self.emojiFooterScrollView.showsVerticalScrollIndicator = NO;
    self.emojiFooterScrollView.contentSize = CGSizeMake(SCREEN_WIDTH - (SCREEN_WIDTH / 5), self.emojiFooterView.height);
    [self.emojiFooterView addSubview:self.emojiFooterScrollView];
    
    self.emojiButotn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 6, 40)];
    self.emojiButotn.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:230 / 255.0 blue:230 / 255.0 alpha:1];
    [self.emojiButotn setImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_nor"] forState:UIControlStateNormal];
    [self.emojiButotn setImage:[UIImage imageNamed:@"liaotian_ic_biaoqing_press"] forState:UIControlStateHighlighted];
    [self.emojiFooterScrollView addSubview:self.emojiButotn];
    
    self.layout = [[CollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor colorWithRed:243 / 255.0 green:243 / 255.0 blue:243 / 255.0 alpha:1];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 140, 0, 10)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    self.pageControl.numberOfPages = self.defaultEmoticons.count / 21;
    [self addSubview:self.pageControl];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.collectionView) {
        self.pageControl.currentPage = (scrollView.contentOffset.x / SCREEN_WIDTH);
    }
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
    cell.string = self.defaultEmoticons[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = self.defaultEmoticons[indexPath.row];
    if (str.length != 0) {
        if ([_delegate respondsToSelector:@selector(emojiButtonView:emojiText:)]) {
            [_delegate emojiButtonView:self emojiText:str];
        }
    }
}

- (void)clickSenderButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(emojiButtonView:sendButtonClick:)]) {
        [_delegate emojiButtonView:self sendButtonClick:sender];
    }
}

@end


