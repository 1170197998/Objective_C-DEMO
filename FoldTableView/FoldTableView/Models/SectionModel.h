//
//  SectionModel.h
//  FoldTableView
//
//  Created by ShaoFeng on 16/7/29.
//  Copyright © 2016年 Cocav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject
@property (nonatomic,copy)NSString *sectionTitle;
@property (nonatomic,strong)NSMutableArray *cellModels;
@property (nonatomic,assign)BOOL isExpanded;
@end
