//
//  CollectionViewFlowLayout.m
//  KeyBoard
//
//  Created by ShaoFeng on 16/8/19.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "CollectionViewFlowLayout.h"

@implementation CollectionViewFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];
    CGFloat W = (self.collectionView.bounds.size.width) / 7;
    CGFloat H = (self.collectionView.bounds.size.height) / 3;

    self.itemSize = CGSizeMake(W, H);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    CGFloat Y = (self.collectionView.bounds.size.height - 3 * H);
    self.collectionView.contentInset = UIEdgeInsetsMake(Y, 0, 0, 0);
}

@end
