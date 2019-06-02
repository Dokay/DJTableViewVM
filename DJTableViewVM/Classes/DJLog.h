//
//  DJLog.h
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/12/8.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDJDebugClass @"c:"
#define kDJDebugHeitht @"h:"
#define kDJDebugPostion @"p:"

__attribute__((weak)) BOOL DJ_LOG_ENABLE;

void DJLog(NSString *format, ...);
