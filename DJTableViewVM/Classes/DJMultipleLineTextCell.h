//
//  DJMultipleLineTextCell.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMCell.h"
#import "DJMultipleLineTextRow.h"

@interface DJMultipleLineTextCell : DJTableViewVMCell

@property(nonatomic, strong) DJMultipleLineTextRow *rowVM;
@property(nonatomic, readonly) UILabel *multipleLinesLabel;

@end
