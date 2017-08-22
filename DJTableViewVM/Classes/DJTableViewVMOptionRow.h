//
//  DJTableViewVMOptionRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/22.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>

@interface DJTableViewVMOptionRow : DJTableViewVMRow

@property(nonatomic, strong) NSString *value;

- (id)initWithTitle:(NSString *)title value:(NSString *)value selectionHandler:(void(^)(DJTableViewVMOptionRow *rowVM))selectionHandler;

@end
