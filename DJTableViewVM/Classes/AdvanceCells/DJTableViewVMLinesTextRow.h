//
//  DJTableViewVMLinesTextRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import "DJTableViewVMRow.h"

@interface DJTableViewVMLinesTextRow : DJTableViewVMRow

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) NSInteger numberOfLines;


@end
