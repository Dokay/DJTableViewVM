//
//  DJLog.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/12/8.
//  Copyright © 2016年 dj226. All rights reserved.
//

#import "DJLog.h"

#define DJ_DEBUG_LOG

@implementation DJLog

+ (void)dj_debugLog:(NSString *)message
{
#ifdef DJ_DEBUG_LOG
    NSLog(@"DJTableViewVM Debug Log => %@ \n",message);
#endif
    
}

@end
