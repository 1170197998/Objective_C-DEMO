//
//  HeaderView.m
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property (nonatomic, strong) UIImageView *directionImageView;
@end

@implementation HeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        self.directionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"expanded"]];
        self.directionImageView.frame = CGRectMake(w - 30, (44 - 8) / 2, 15, 8);
        [self.contentView addSubview:self.directionImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onExpand:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(0, 0, w, 44);
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, w, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
        
        self.contentView.backgroundColor = [UIColor greenColor];
    }
    return self;
}

- (void)setSectionModel:(SectionModel *)sectionModel
{
    _sectionModel = sectionModel;
    self.textLabel.text = sectionModel.sectionTitle;
    
    if (sectionModel.isExpanded) {
        self.directionImageView.transform = CGAffineTransformIdentity;
    } else {
        self.directionImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }
}

- (void)onExpand:(UIButton *)sender {
    self.sectionModel.isExpanded = !self.sectionModel.isExpanded;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.sectionModel.isExpanded) {
            self.directionImageView.transform = CGAffineTransformIdentity;
        } else {
            self.directionImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    }];
    
    if (self.expandCallBack) {
        self.expandCallBack(self.sectionModel.isExpanded);
    }
}

@end
