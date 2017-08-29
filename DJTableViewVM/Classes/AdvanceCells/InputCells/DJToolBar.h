//
//  DJToolBar.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/6.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJToolBar : UIToolbar

@property(nonatomic, assign) BOOL preEnable;
@property(nonatomic, assign) BOOL nextEnable;

@property(nonatomic, copy) void(^tapPreHandler)(void);
@property(nonatomic, copy) void(^tapNextHandler)(void);
@property(nonatomic, copy) void(^tapDoneHandler)(void);

@end
