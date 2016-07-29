//
//  TableViewCell.m
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier\
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setCellModel:(CellModel *)cellModel
{
    _cellModel = cellModel;
    self.textLabel.text = cellModel.cellTitle;
}

@end
