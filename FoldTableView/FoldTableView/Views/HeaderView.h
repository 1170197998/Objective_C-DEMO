//
//  HeaderView.h
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionModel.h"

typedef void (^HeaderViewClickCallBack)(BOOL isExpanded);

@interface HeaderView : UITableViewHeaderFooterView

@property (nonatomic,strong)SectionModel *sectionModel;
@property (nonatomic,copy)HeaderViewClickCallBack expandCallBack;

@end
