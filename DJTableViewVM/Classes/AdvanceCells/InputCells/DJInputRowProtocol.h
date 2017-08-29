//
//  DJInputRowProtocol.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 2017/3/14.
//  Copyright © 2017年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DJInputRowProtocol <NSObject>

@required
@property (nonatomic, assign) BOOL enabled;//whether cell is edit enable
@property (nonatomic, assign) UITableViewScrollPosition focusScrollPosition;//scrollPosition for cell be focus while input.it works when keyboardManageEnabled in DJTableViewVM set YES.

@optional
@property (nonatomic, strong) UIColor *toolbarTintColor;

@end
