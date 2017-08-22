//
//  DJTableViewVMBoolRow.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/8/21.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <DJTableViewVMFrameWork/DJTableViewVMFrameWork.h>

@class DJTableViewVMBoolRow;
typedef void(^switchValueChangeBlock)(DJTableViewVMBoolRow *rowVM);

@interface DJTableViewVMBoolRow : DJTableViewVMRow

@property (nonatomic, assign) BOOL value;
@property (nonatomic, copy) switchValueChangeBlock valueChangeBlock;

- (instancetype)initWithTitle:(NSString *)aTitle value:(BOOL)aValue valueChangeHander:(switchValueChangeBlock)valueChangeBlock;

@end
