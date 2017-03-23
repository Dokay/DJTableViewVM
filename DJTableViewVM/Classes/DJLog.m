//
//  DJLog.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/12/8.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJLog.h"

__attribute__((weak)) BOOL DJ_LOG_ENABLE;

void DJLog(NSString *format, ...)
{
    if (DJ_LOG_ENABLE) {
        va_list args;
        va_start(args, format);
        
        NSString *logFormat = [NSString stringWithFormat:@"\nDJTableViewVM Debug Log => %@ \n\n",format];
        NSLogv(logFormat,args);
        
        va_end(args);
    }
}
