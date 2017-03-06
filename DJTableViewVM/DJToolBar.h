//
//  DJToolBar.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/6.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJToolBar : UIToolbar

@property(nonatomic, strong) NSString *doneTitle;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, assign) BOOL preEnable;
@property(nonatomic, assign) BOOL nextEnable;

@property(nonatomic, copy) void(^tapPreHandler)();
@property(nonatomic, copy) void(^tapNextHandler)();
@property(nonatomic, copy) void(^tapDoneHandler)();

@end
